# Privacy Policy — learn1000words

_Last updated: 2026-07-16_

This policy describes how the **learn1000words** app handles your data. It reflects what the
app actually does today. Placeholders in **[brackets]** must be filled in before publishing.

## Who we are

learn1000words is a vocabulary-learning app. For any privacy question or request, contact us at
**ermellinodavide@gmail.com**.

## The short version

- To use the app you sign in with **Google** or **email + password** (on Android). **Sign in with
  Apple** is implemented for a future iOS release and is not available in this Android version.
- We store your **learning profile** (nickname, chosen avatar, active language pair, level,
  memorized-word count, streak) and **which words you have memorized** in our cloud backend so
  your progress is backed up and restored when you sign in on another device.
- Certain profile details are **visible to other users** by design (see "Friends" below).
- We do **not** use any advertising, analytics, or tracking services.
- Some data (your written practice sentences, your daily goal, and reminder settings) **never
  leaves your device**.

## Data we collect and why

### Account & sign-in
- **Email address** — used to create and identify your account. Collected when you sign up or
  sign in with email/password, or supplied by Google when you use that sign-in method.
- **Password** (email sign-in only) — used to authenticate you. It is handled by our
  authentication provider (Supabase Auth) and stored only in hashed form on the server; the app
  never stores your password.
- Sign-in is handled by **Supabase Auth**, and, if you choose it, by **Google Sign-In**. That
  provider processes your credentials under its own privacy policy.
- **Sign in with Apple** is built into the app for a planned iOS release and is not offered in
  this Android version — the option does not appear on Android devices.

### Learning profile (backed up to the cloud)
When you complete setup we create a profile containing:
- **Nickname** — a display name you choose. It must be unique and is **searchable by other
  users** and shown to your friends.
- **Avatar** — an image you pick from a built-in set (an id number; no photo is uploaded).
- **Active language pair, current level, memorized-word count, and streak** — your progress.

### Learning progress
- **Memorized words** — the specific vocabulary items you have marked as memorized, with the
  date. This is stored in the cloud so it can be restored on a new device. It is kept **private
  to your account** and is **not** shown to friends.

### Friends
If you use the friends feature, we store your **friend requests** and **friendships** (who you
are connected with). When you and another user are friends, they can see your **nickname,
avatar, active language pair, current level, and memorized-word count**. Any signed-in user can
find you by searching your nickname, which reveals your **nickname and avatar**. Your individual
memorized words, your practice sentences, your email, and your daily/reminder settings are
**never** shared with other users.

### Stays on your device only
The following are stored only on your device and are never transmitted to us:
- **Practice sentences** you write in Usage mode.
- **Daily goal** and **reminder time**.
- Your **daily activity history** (used to calculate your streak).

### Notifications
The app can show a **daily local reminder** notification. This is scheduled on your device; we do
not operate a push-notification service and do not collect any notification token.

## Where your data is stored

Cloud data (account, profile, memorized words, friends) is stored with **Supabase**, our backend
provider. **[Data region — confirm in the Supabase dashboard and state it here, e.g. "European
Union". Do not claim a region until verified.]**

## What we do NOT do

- We do **not** use advertising networks.
- We do **not** use analytics or usage-tracking SDKs.
- We do **not** use crash-reporting SDKs.
- We do **not** sell your data or share it with third parties for their own purposes. The only
  third parties involved are the service providers named above (Supabase for backend/auth,
  Google for the sign-in method if you choose it).

## Your choices and controls

- **Sign out.** Signing out removes the app's data from your device. Your cloud data remains and
  is restored the next time you sign in.
- **Account & data deletion.** You can delete your account and all associated data at any time,
  **immediately and irreversibly**:
  - **In the app:** go to **Profile → Account → Delete account** and confirm. Your cloud data,
    your account, and all data on your device are removed right away.
  - **Without the app:** email **ermellinodavide@gmail.com** with the subject "Account deletion request"
    from your registered address; the account and its data are deleted immediately upon
    verification. See also our web deletion page (`docs/delete-account.html`).

## Children

The app is not directed at children. **[State your minimum-age position here if required by your
Play Console content rating.]**

## Changes to this policy

We may update this policy; the "Last updated" date above will change accordingly.

## Contact

**ermellinodavide@gmail.com**

---

_Notes for the author (remove before publishing):_
- _Fill every **[bracketed]** placeholder._
- _Confirm the Supabase region before naming it._
- _This policy intentionally does not claim GDPR/CCPA "compliance"; it describes practices only._
- _Account deletion now describes the in-app flow (Profile → Account → Delete account, backed by
  the `delete-account` Supabase edge function) plus an email path for users without the app. The
  static web versions live in `docs/privacy-policy.html` and `docs/delete-account.html`._
- _This release is Android-only; Apple Sign-in is implemented but only shown on iOS/macOS builds
  (`auth_screen.dart` gates it by platform), so it is mentioned as "planned for iOS" rather than
  as an active Android feature. It remains unverified on a real Apple device._
