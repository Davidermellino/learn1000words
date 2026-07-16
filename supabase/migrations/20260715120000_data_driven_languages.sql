-- P8: data-driven languages — progress becomes per language pair.
--
-- Local Drift is wiped on upgrade (old test data is expendable), so the cloud
-- side is brought in line the same way: memorized_words is re-keyed to
-- include pair_id, and profiles.language_pair now holds the active pairId
-- (e.g. 'it_hu') instead of the old enum name ('itHu').
--
-- IMPORTANT: run the truncate snippet at the bottom FIRST on any project that
-- already has rows — the pair_id backfill below is only a placeholder for
-- empty tables. RLS behaviour is unchanged (self-write; friends read the
-- aggregate profile columns, which now include language_pair).

-- ---------------------------------------------------------------------------
-- memorized_words: add pair_id and re-key PK to (user_id, pair_id, word_id).
-- ---------------------------------------------------------------------------
alter table public.memorized_words
  add column pair_id text not null default '';

alter table public.memorized_words
  drop constraint memorized_words_pkey;

alter table public.memorized_words
  add primary key (user_id, pair_id, word_id);

-- Drop the placeholder default; the client always supplies pair_id now.
alter table public.memorized_words
  alter column pair_id drop default;

-- ---------------------------------------------------------------------------
-- profiles.language_pair now stores the active pairId (e.g. 'it_hu').
-- ---------------------------------------------------------------------------
alter table public.profiles
  alter column language_pair set default 'it_hu';

-- ---------------------------------------------------------------------------
-- One-time data reset (run manually — see the P8 objective; NOT auto-run):
--
--   truncate table public.memorized_words;
--   update public.profiles
--     set language_pair = 'it_hu', memorized_count = 0, current_level = 1;
--
-- (memorized_words has no rows worth keeping once it is re-keyed; profiles
-- are reset to the default pair so the client re-derives per-pair aggregates
-- on its next push.)
-- ---------------------------------------------------------------------------
