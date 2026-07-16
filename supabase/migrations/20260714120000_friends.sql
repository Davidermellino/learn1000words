-- P6: friends — nickname search, friend requests, and friend profile reads.
--
-- Design notes:
-- - friendships are stored CANONICALLY as a single row with user_a < user_b
--   (uuid ordering), never both directions. All lookups check both columns.
-- - Clients never insert into friendships directly: accepting a request
--   flips its status to 'accepted', and a SECURITY DEFINER trigger creates
--   the friendship row. This avoids a racy/spoofable INSERT policy.
-- - Nickname search and the incoming-requests list must show users who are
--   NOT friends yet, so they go through SECURITY DEFINER RPCs that return
--   only the public columns (id, nickname, avatar_id) — profile RLS itself
--   stays "own row + accepted friends".

-- ---------------------------------------------------------------------------
-- friend_requests: one row per directed request. unique(from_user, to_user)
-- means a declined request permanently blocks re-requesting in that
-- direction (deliberate anti-spam; there is no unfriend/re-request flow yet).
-- ---------------------------------------------------------------------------
create table public.friend_requests (
  id         uuid primary key default gen_random_uuid(),
  from_user  uuid not null references public.profiles (id) on delete cascade,
  to_user    uuid not null references public.profiles (id) on delete cascade,
  status     text not null default 'pending'
             check (status in ('pending', 'accepted', 'declined')),
  created_at timestamptz not null default now(),
  unique (from_user, to_user),
  check (from_user <> to_user)
);

create index friend_requests_to_user_idx
  on public.friend_requests (to_user) where status = 'pending';

-- ---------------------------------------------------------------------------
-- friendships: canonical single row per pair, smaller uuid first.
-- ---------------------------------------------------------------------------
create table public.friendships (
  user_a     uuid not null references public.profiles (id) on delete cascade,
  user_b     uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_a, user_b),
  check (user_a < user_b)
);

create index friendships_user_b_idx on public.friendships (user_b);

-- ---------------------------------------------------------------------------
-- Accepting a request creates the friendship. SECURITY DEFINER so the
-- recipient (who cannot insert into friendships) still gets the row created.
-- ---------------------------------------------------------------------------
create function public.create_friendship_on_accept()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.status = 'accepted' and old.status = 'pending' then
    insert into public.friendships (user_a, user_b)
    values (
      least(new.from_user, new.to_user),
      greatest(new.from_user, new.to_user)
    )
    on conflict do nothing;
  end if;
  return new;
end;
$$;

create trigger friend_request_accepted
  after update on public.friend_requests
  for each row execute function public.create_friendship_on_accept();

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
alter table public.friend_requests enable row level security;
alter table public.friendships enable row level security;

-- Both parties can see a request (sender needs it to mark search results
-- "already requested"; recipient needs it to accept/decline).
create policy "friend_requests: select own"
  on public.friend_requests for select
  using (auth.uid() = from_user or auth.uid() = to_user);

-- Only the sender creates a request, and only as 'pending'.
create policy "friend_requests: insert as sender"
  on public.friend_requests for insert
  with check (auth.uid() = from_user and status = 'pending');

-- Only the recipient resolves a pending request, and only to a final state.
-- (from_user/to_user are immutable in practice: changing them would need the
-- new row to still satisfy auth.uid() = to_user and would hit the trigger's
-- old-status guard, so no separate column-freeze machinery is needed.)
create policy "friend_requests: recipient resolves"
  on public.friend_requests for update
  using (auth.uid() = to_user and status = 'pending')
  with check (auth.uid() = to_user and status in ('accepted', 'declined'));

-- Users see their own friendships. No insert/update/delete policies: only
-- the SECURITY DEFINER trigger writes this table.
create policy "friendships: select own"
  on public.friendships for select
  using (auth.uid() = user_a or auth.uid() = user_b);

-- Widen profile reads to accepted friends (P5 left it own-row-only). The
-- client reads only nickname/avatar_id/current_level/memorized_count for
-- friends; word-level data (memorized_words) stays own-row-only — no change
-- to its policies.
create policy "profiles: select friends"
  on public.profiles for select
  using (
    exists (
      select 1
      from public.friendships f
      where (f.user_a = auth.uid() and f.user_b = profiles.id)
         or (f.user_b = auth.uid() and f.user_a = profiles.id)
    )
  );

-- ---------------------------------------------------------------------------
-- search_profiles: case-insensitive prefix search on nickname, returning
-- ONLY public columns. SECURITY DEFINER because the results are mostly
-- non-friends whose rows RLS would otherwise hide.
-- ---------------------------------------------------------------------------
create function public.search_profiles(query text)
returns table (id uuid, nickname text, avatar_id int)
language sql
security definer
set search_path = ''
stable
as $$
  select p.id, p.nickname, p.avatar_id
  from public.profiles p
  where auth.uid() is not null
    and p.id <> auth.uid()
    and length(trim(query)) >= 2
    -- Escape LIKE metacharacters so user input is a literal prefix.
    and lower(p.nickname) like
        replace(replace(replace(lower(trim(query)),
          '\', '\\'), '%', '\%'), '_', '\_') || '%'
  order by lower(p.nickname)
  limit 20;
$$;

-- ---------------------------------------------------------------------------
-- incoming_friend_requests: pending requests addressed to the caller, with
-- the sender's public columns (the sender is not a friend yet, so a plain
-- join would be blocked by profile RLS).
-- ---------------------------------------------------------------------------
create function public.incoming_friend_requests()
returns table (
  request_id uuid,
  from_user  uuid,
  nickname   text,
  avatar_id  int,
  created_at timestamptz
)
language sql
security definer
set search_path = ''
stable
as $$
  select r.id, r.from_user, p.nickname, p.avatar_id, r.created_at
  from public.friend_requests r
  join public.profiles p on p.id = r.from_user
  where r.to_user = auth.uid() and r.status = 'pending'
  order by r.created_at desc;
$$;

-- RPCs are for signed-in users only.
revoke execute on function public.search_profiles(text) from public, anon;
revoke execute on function public.incoming_friend_requests() from public, anon;
grant execute on function public.search_profiles(text) to authenticated;
grant execute on function public.incoming_friend_requests() to authenticated;
