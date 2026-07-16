# Supabase Setup Checklist (P5)

Dashboard steps that must be done by hand before cloud sync works. The app
runs fully local without any of this — sync activates only when the
`--dart-define`s below are passed.

## 1. Create the Supabase project

1. https://supabase.com/dashboard → **New project** (name e.g. `learn1000words`,
   region close to you, EU for GDPR comfort).
2. From **Project Settings → API** note down:
   - **Project URL** → becomes `SUPABASE_URL`
   - **anon / public key** → becomes `SUPABASE_ANON_KEY`

Both values are safe to embed in a build (RLS protects the data), but keep
them out of git anyway: they are passed at build time only.

## 2. Run the migration

Either paste `supabase/migrations/20260714000000_profiles_and_memorized_words.sql`
into **SQL Editor → New query → Run**, or with the Supabase CLI:

```
supabase link --project-ref <project-ref>
supabase db push
```

Verify: **Table Editor** shows `profiles` and `memorized_words`, both with
RLS enabled (shield icon). A second test account must not be able to select
another user's rows.

## 3. Enable the Email provider

**Authentication → Sign In / Providers → Email**: enabled by default.

- For frictionless testing, turn **Confirm email** OFF (otherwise sign-up
  sends a confirmation link and the app tells the user to confirm first —
  the app handles both modes).

## 4. Google Sign-In (Android — needed now)

1. Google Cloud console (https://console.cloud.google.com) → create/pick a
   project → **APIs & Services → OAuth consent screen**: configure (External,
   app name, your email; test users are enough while in Testing).
2. **Credentials → Create credentials → OAuth client ID**, twice:
   - **Web application** → this client id (ends in
     `.apps.googleusercontent.com`) is both the app's
     `GOOGLE_WEB_CLIENT_ID` *and* what Supabase verifies.
   - **Android** → package name `com.ermellino.learn1000words` + the **debug
     SHA-1**. Get it with:

     ```powershell
     # PowerShell (Windows): gradlew needs JAVA_HOME pointed at the JBR
     $env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
     cd android; .\gradlew.bat signingReport
     ```

     Or read it straight off the debug keystore, no Gradle needed:
     `keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android`
     (keytool lives in `C:\Program Files\Android\Android Studio\jbr\bin` if not on PATH).
     ⚠️ Without this SHA-1 registration, native Google Sign-In on Android
     fails with a developer error. Release signing will need its own SHA-1
     later.
3. Supabase **Authentication → Sign In / Providers → Google**: enable, paste
   the **web** client ID into *Client IDs* (secret not needed for native
   ID-token flow; add it only if you also want browser OAuth).

## 5. Run the app with sync enabled

```
flutter run \
  --dart-define=SUPABASE_URL=https://<project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon key> \
  --dart-define=GOOGLE_WEB_CLIENT_ID=<web client id>.apps.googleusercontent.com
```

Or keep a git-ignored `env.json` (already in `.gitignore`):

```json
{
  "SUPABASE_URL": "https://<project>.supabase.co",
  "SUPABASE_ANON_KEY": "<anon key>",
  "GOOGLE_WEB_CLIENT_ID": "<web client id>.apps.googleusercontent.com"
}
```

```
flutter run --dart-define-from-file=env.json
```

Never hardcode these values in source.

## 6. Sign in with Apple (later — P5.5, needs Codemagic/TestFlight)

The client code is implemented (`AuthService.signInWithApple`, iOS-only
button) but **unverified until the app runs on a real Apple device**.

1. Apple Developer portal:
   - App ID for the bundle id with the **Sign in with Apple** capability.
   - A **Services ID** (for Supabase's web fallback) with the Supabase
     callback URL `https://<project>.supabase.co/auth/v1/callback`.
   - A **Sign in with Apple key** (.p8); note Key ID and Team ID.
2. Supabase **Authentication → Sign In / Providers → Apple**: enable; add the
   app's **bundle id** to *Authorized Client IDs* (needed for the native
   ID-token flow); Services ID/secret only for web OAuth.
3. Xcode: Runner target → **Signing & Capabilities → + Sign in with Apple**.
4. Google on iOS additionally needs: an **iOS OAuth client** in Google Cloud
   → pass as `--dart-define=GOOGLE_IOS_CLIENT_ID=...` and put its
   **reversed** client id into `ios/Runner/Info.plist` (placeholder marked
   `REPLACE-WITH-REVERSED-GOOGLE-IOS-CLIENT-ID`).
5. Optional hardening for P5.5: add `package:crypto` so the Apple flow can
   send a hashed nonce (currently omitted — GoTrue accepts nonce-less Apple
   tokens; see the TODO in `auth_service.dart`).

## How sync behaves (for reference)

- Local Drift stays the source of truth; Supabase is a mirror/backup.
- On sign-in: first time → the nickname is claimed globally (unique,
  case-insensitive; on conflict the app prompts for another); returning
  account → cloud profile + memorized words are pulled and merged (union —
  "memorized" only grows), then everything is pushed back.
- After each newly memorized word: debounced (3 s) push of the profile row
  and the new `memorized_words` rows.
- Offline: a pending flag is stored locally; the push retries every 60 s
  while the app runs and on the next launch. No data is ever deleted by sync.
