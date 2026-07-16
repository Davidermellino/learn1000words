# Data Safety Inventory — learn1000words

_Audit date: 2026-07-16. Derived strictly from the source in this repository. Every
row cites where the data is collected, stored, or transmitted. "Verify manually" marks
anything not determinable from code alone (e.g. dashboard-side settings)._

## Summary of findings

- **No analytics, advertising, crash-reporting, or tracking SDK is present.** The only
  network-touching dependencies are `supabase_flutter` (auth + sync) and `google_sign_in`
  (login) — this Android-only release does not offer Apple sign-in. Verified against
  `pubspec.yaml` and a repo-wide grep for firebase/crashlytics/sentry/analytics/admob/etc.
  — no matches.
- **Cloud sync is optional at build time.** Without the `SUPABASE_URL` / `SUPABASE_ANON_KEY`
  dart-defines the app runs fully local with no auth and no transmission
  (`lib/core/config/env.dart:27-29`, `lib/main.dart:41-53`). The shipped `env.json`
  configures Supabase, so a Play release built with it **does** transmit the data below.
- **Auth is mandatory** in configured builds: the router gates everything behind sign-in
  (Google / email+password; this Android-only release does not offer Apple sign-in).
- **In-app account deletion exists.** Profile → Account → Delete account calls the
  `delete-account` Supabase edge function (removes all cloud rows + the auth user via the
  service role, self-delete only), then wipes local Drift data and ends the session (see
  "User rights & deletion" below). A web deletion path also exists for users without the app.

## Third parties / SDKs

| Party | Purpose | Evidence |
|---|---|---|
| Supabase (backend: Postgres + GoTrue auth + Edge Functions) | Account auth, profile & progress cloud sync, friends, account deletion (`delete-account` edge function) | `lib/main.dart:44-49`, `lib/data/supabase/supabase_providers.dart`, `supabase/migrations/**`, `supabase/functions/delete-account/index.ts` |
| Google Sign-In | Optional login method (ID-token exchange to Supabase) | `lib/features/auth/auth_service.dart:46-92`, `google_sign_in` in `pubspec.yaml:49` |

No advertising or analytics third parties. Apple sign-in exists in the codebase but is **not
offered in this Android-only release** (unverified on a real Apple device), so it collects
nothing here.

## Data categories

### Collected & transmitted to Supabase

| Data | What it is | Where stored | Leaves device? | Shared with other users? | Code reference |
|---|---|---|---|---|---|
| **Email address** | The address used for email/password sign-in or sign-up; also the email inside the Google ID token used to create the account | Supabase **Auth** (`auth.users`), managed by GoTrue. The app's own `profiles` table does **not** store email. | Yes | No | `lib/features/auth/auth_screen.dart:126-183`, `lib/features/auth/auth_service.dart:131-156` (email); `:68-92` (Google) |
| **Password** | Email-auth password | Handled entirely by Supabase Auth (hashed server-side); never persisted by the app | Yes (to Supabase Auth at sign-in) | No | `lib/features/auth/auth_service.dart:131-156` |
| **Nickname** | User-chosen display name; globally unique (case-insensitive) | `profiles.nickname` (Supabase) + local Drift `Profiles` | Yes | **Yes** — searchable by prefix by any signed-in user, and shown to friends | `supabase/migrations/20260714000000...sql` (profiles), `search_profiles` RPC in `...friends.sql`; `lib/data/repositories/friends_repository.dart:773-781` |
| **Avatar id** | Integer selecting a bundled avatar image (no photo uploaded) | `profiles.avatar_id` + local Drift | Yes | **Yes** — returned in search results & to friends | `...friends.sql` (`search_profiles`, `profiles: select friends`); `friends_repository.dart:797-803` |
| **Active language pair** | The pair id currently being studied (e.g. `it_hu`) | `profiles.language_pair` + local Drift | Yes | **Yes** — visible to accepted friends | `lib/data/sync/sync_service.dart:413-422`; `friends_repository.dart:797-803` |
| **Current level** | Progression level (1–10) | `profiles.current_level` + local Drift | Yes | **Yes** — visible to accepted friends | `sync_service.dart:413-422`; `friends_repository.dart:797-803` |
| **Memorized count** | Aggregate number of memorized words in the active pair | `profiles.memorized_count` + local Drift | Yes | **Yes** — visible to accepted friends | `sync_service.dart:413-422`; `friends_repository.dart:797-803` |
| **Streak** | Consecutive-day streak counter | `profiles.streak` + local Drift | Yes | No (not selected in the friends query) | `sync_service.dart:413-422` (pushed); `friends_repository.dart:797-803` (not read back for friends) |
| **Memorized words (per-word)** | One row per memorized word: `(user_id, pair_id, word_id, memorized_at)` — which specific vocabulary items the user has learned and when | `memorized_words` (Supabase) + local Drift `WordProgress` | Yes | **No** — RLS is own-row only; not exposed to friends | `sync_service.dart:395-411`; `...profiles_and_memorized_words.sql`, `...data_driven_languages.sql` |
| **Friend requests** | Directed request rows `(from_user, to_user, status)` | `friend_requests` (Supabase) | Yes | Between the two parties only | `...friends.sql`; `friends_repository.dart:816-854` |
| **Friendships** | Who the user is friends with | `friendships` (Supabase) | Yes | To both members of the pair | `...friends.sql`; `friends_repository.dart:784-804` |

### Stored on device only (never transmitted)

| Data | What it is | Where | Code reference |
|---|---|---|---|
| **Usage sentences** | Free-text sentences the user writes in Usage mode (ungraded). Kept with target word id + timestamp. | Local Drift `UsageSentences` only. **Not** in any migration or sync push. | `lib/core/db/app_database.dart` (`UsageSentences`), `lib/features/usage/usage_repository.dart` |
| **Daily goal** | Words-per-day target | Local Drift `Profiles.dailyGoal` | `app_database.dart` (`Profiles`), `profile_repository.dart:628-633` |
| **Reminder time** | Hour/minute for the daily notification | Local Drift `Profiles.reminderHour/Minute` | `app_database.dart`, `profile_repository.dart:637-644` |
| **Daily activity history** | Per-day memorized count + goal-met flag (backs streak) | Local Drift `DailyActivity` | `app_database.dart` (`DailyActivity`) |
| **Sync bookkeeping** | Pending-push flag, last-pushed cursor | Local Drift `AppMeta` | `sync_service.dart:544-557` |

Note: `dailyGoal`, reminder time, usage sentences, and daily-activity history are **device-local**
and are not restored on a new device (`account_linker.dart:118-121` explicitly keeps daily-goal/reminder
defaults on restore).

## Device permissions (Android)

| Permission | Reason | Reference |
|---|---|---|
| `INTERNET` | Supabase auth + sync | `android/app/src/main/AndroidManifest.xml` |
| `POST_NOTIFICATIONS` | Daily study-reminder notification (Android 13+) | same |
| `SCHEDULE_EXACT_ALARM` | Exact daily reminder (inexact fallback if denied) | same |
| `RECEIVE_BOOT_COMPLETED` | Re-register the scheduled reminder after reboot | same |

Notifications are local-only (`flutter_local_notifications`); no push-notification service or
token collection is present (`lib/core/notifications/notification_service.dart`).

## User rights & deletion (as implemented)

- **Sign-out** (`account_linker.dart:144` → `signOutAndUnlink`) signs out of Supabase and
  **wipes on-device data** (`app_database.dart` `clearLocalData`). Cloud rows are **not**
  deleted — they are restored on the next login.
- **In-app account & data deletion.** Profile → Account → **Delete account**
  (`profile_screen.dart` `_confirmDeleteAccount` → `AccountDeleter.deleteAccount`,
  `lib/features/auth/account_deleter.dart`) performs an **immediate, irreversible** deletion:
  1. The client calls the `delete-account` Supabase **edge function**
     (`supabase/functions/delete-account/index.ts`), attaching the caller's own JWT. The
     function verifies that JWT with the anon key, then — using the **service role key**
     (server-side only) — deletes the caller's rows from `friend_requests`, `friendships`,
     `memorized_words`, and `profiles`, and finally the `auth.users` record itself via the
     Admin API. It **only ever deletes the calling user** (no client-supplied id).
  2. The client then signs out, clears sync bookkeeping, and wipes all local Drift data
     (`clearLocalData`), so no session or on-device data remains and the router returns the
     user to the registration screen.
- **Web deletion path.** For users who no longer have the app, `docs/delete-account.html`
  documents an email request (subject "Account deletion request", from the registered
  address) resulting in immediate deletion upon verification.
- The service role key is referenced **only** inside the edge function's server-side
  environment (`SUPABASE_SERVICE_ROLE_KEY`); it never appears in client/Dart code.

## Items to verify manually

1. **Supabase data region.** Not in code — a dashboard setting. `SUPABASE_SETUP.md` recommends
   "EU for GDPR comfort," but the actual region of project `zybxqvorynbvpaabywvd` must be
   confirmed in the Supabase dashboard before stating it in the privacy policy.
2. **Whether Supabase Auth retains Google `name`/email in user metadata.** Confirm what GoTrue
   stores in `auth.users.raw_user_meta_data` for your project.
3. **Email confirmation setting.** `SUPABASE_SETUP.md` suggests turning "Confirm email" off for
   testing — confirm the production setting.
4. **Deploy the `delete-account` edge function** and verify end-to-end: deleting an account
   removes its rows from every table and its `auth.users` record, leaves other users untouched,
   and returns the client to the registration screen. The function relies on the default
   `SUPABASE_URL` / `SUPABASE_ANON_KEY` / `SUPABASE_SERVICE_ROLE_KEY` secrets Supabase injects
   into functions — no manual secret setup needed.
5. **Contact email** for the privacy policy / deletion page (placeholder used in the drafts and
   `docs/*.html`).
