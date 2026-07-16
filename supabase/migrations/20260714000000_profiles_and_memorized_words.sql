-- P5: cloud mirror of the local profile + memorized-word set.
--
-- Design note: memorized words are stored per-row (user_id, word_id) rather
-- than as an aggregate count, because restoring progress on a fresh install
-- needs the actual word ids, and P6 (friends) can build on the same table.
-- "Memorized" only ever grows, so sync is a safe merge (upserts only, no
-- deletes).

-- ---------------------------------------------------------------------------
-- profiles: one row per auth user, mirroring the local Drift profile.
-- ---------------------------------------------------------------------------
create table public.profiles (
  id              uuid primary key references auth.users (id) on delete cascade,
  nickname        text not null,
  avatar_id       int  not null default 0,
  language_pair   text not null default 'itHu',
  memorized_count int  not null default 0,
  current_level   int  not null default 1,
  streak          int  not null default 0,
  updated_at      timestamptz not null default now()
);

-- Global nickname uniqueness, case-insensitive ("Anna" == "anna").
-- The client claims a nickname by inserting its profile row and treating a
-- 23505 unique violation as "taken, pick another".
create unique index profiles_nickname_lower_key
  on public.profiles (lower(nickname));

-- ---------------------------------------------------------------------------
-- memorized_words: the set of word ids (from the bundled dataset) each user
-- has memorized. Insert-only from the client's perspective.
-- ---------------------------------------------------------------------------
create table public.memorized_words (
  user_id      uuid not null references public.profiles (id) on delete cascade,
  word_id      int  not null,
  memorized_at timestamptz not null default now(),
  primary key (user_id, word_id)
);

-- ---------------------------------------------------------------------------
-- Row Level Security: a user can only touch their own rows.
-- (P6 will widen SELECT for friends; keep it own-rows-only for now.)
-- ---------------------------------------------------------------------------
alter table public.profiles enable row level security;
alter table public.memorized_words enable row level security;

create policy "profiles: select own"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles: insert own"
  on public.profiles for insert
  with check (auth.uid() = id);

create policy "profiles: update own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "memorized_words: select own"
  on public.memorized_words for select
  using (auth.uid() = user_id);

create policy "memorized_words: insert own"
  on public.memorized_words for insert
  with check (auth.uid() = user_id);

create policy "memorized_words: update own"
  on public.memorized_words for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- No DELETE policies: memorized progress only grows, and profiles are
-- removed via the auth.users cascade when an account is deleted.
