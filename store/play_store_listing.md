# Google Play Store Listing — learn1000words

_Describes only features present and working in the current code. No unshipped or
aspirational claims. Character counts noted against Play's limits._

## App name
learn1000words

## Short description (≤ 80 characters)

> Learn vocabulary with flashcards, tests, streaks, and friends — synced anywhere.

_(78 characters)_

Alternative (72 chars):
> Build your vocabulary with flashcards, quizzes, streaks and friends.

## Full description (≤ 4000 characters)

> **learn1000words** helps you build vocabulary in a new language, one word at a time —
> with flashcards, quick tests, and a daily habit that keeps you coming back.
>
> **Study the way that works for you**
> • Flip through **flashcards** to learn word pairs.
> • Take short **tests** to check what you remember.
> • Write your own **example sentences** in Usage mode to practise words in context —
>   they're saved so you can look back over them.
> • Track each word as you go: everything is organised into **levels**, so you always
>   know what to tackle next.
>
> **Choose your languages**
> The app is built around **language pairs**. Pick the pair you want to study, and your
> progress is tracked separately for each one — switch any time without losing your place.
>
> **Stay motivated**
> • Set a **daily goal** for how many new words you want to memorise.
> • Keep your **streak** alive by hitting your goal each day.
> • Get a gentle **daily reminder** at a time you choose.
>
> **Learn with friends**
> • Find friends by searching their **nickname**.
> • Send and accept **friend requests**.
> • See your friends' progress — their active language, level, and how many words
>   they've memorised — for a bit of friendly motivation.
>
> **Your progress, backed up**
> Sign in with **Google** or **email** and your profile and memorised words are safely
> **backed up to the cloud**. Get a new phone? Sign in and everything is restored. Your
> progress is also kept **on your device**, so studying keeps working smoothly.
>
> **No ads, no tracking**
> learn1000words contains **no advertising and no analytics or tracking services**. The
> words you practise with are the focus — nothing else.
>
> Start building your vocabulary today.

_(~1,540 characters — well under the 4,000 limit. Trim or expand freely.)_

## Notes for the author

- **"1000 words" in the name** describes the concept, not a guaranteed bundled library size.
  The current bundled dataset ships a small placeholder set (see `AppConstants.wordsPerLevel`
  comment and `assets/words/`). Confirm the shipped word count before making any quantity claim
  in the listing or screenshots.
- **Apple sign-in** is not mentioned in this Android listing: the button is code-gated to
  iOS/macOS only (`auth_screen.dart:73-77`) and never appears on Android, so it isn't a real
  feature of this build regardless of listing wording. It's documented as "planned for iOS" in
  the privacy policy and data safety inventory, not as an active Android feature. Add it to the
  Play listing only once (or if) a verified iOS/App Store release exists — it has no place in
  an Android listing before then.
- **Friends visibility** wording matches what the code actually exposes to friends: nickname,
  avatar, active language pair, level, and memorized count (not individual words, not streak).
- The listing makes **no claims** about grading of usage sentences (they are saved, ungraded)
  or about specific supported languages — add those only once the shipped dataset is finalised.
