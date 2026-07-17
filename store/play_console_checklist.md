# Play Console launch checklist — learn1000words

Everything below is done **by hand in the Play Console web UI** (or the Supabase
dashboard) — this repo can't perform it. Session-generated artifacts are ready:

| Artifact | Location | Console field |
|---|---|---|
| Signed app bundle | `build/app/outputs/bundle/release/app-release.aab` (v1.0.0, code 1) | Production → upload |
| High-res icon (512×512) | `store/graphics/icon_512.png` | Store listing → App icon |
| Feature graphic (1024×500) | `store/graphics/feature_graphic_1024x500.png` | Store listing → Feature graphic |
| Listing copy | `store/play_store_listing.md` | Store listing → text fields |
| Privacy policy (source) | `store/privacy_policy.md` → hosted `docs/privacy-policy.html` | App content → Privacy policy |

`applicationId` = `com.ermellino.learn1000words`. Signed with the **upload** key
(`CN=David Ermellino, O=Ermellino, C=IT`) — verified. Enroll in **Play App
Signing** when prompted (recommended); Google then re-signs with the app key.

> **Rebuild command (important):** the release **must** be built with the
> Supabase/Google config injected, or the app stalls on a "Cloud sync is not
> configured" screen (auth is mandatory):
> `flutter build appbundle --release --dart-define-from-file=env.json`
> (`env.json` is the gitignored secrets file at the repo root.)

---

## 0. Blockers to clear before the store can go live
Carried over from `store/data_safety_inventory.md` §"Items to verify manually" —
these are launch-gating, not console fields:

- [ ] **Deploy the `delete-account` Supabase edge function** and test end-to-end
      (deleting an account clears every table + `auth.users`, leaves others intact).
      Play's data-deletion declaration and the deletion pages assume it's live.
- [ ] **Host the privacy policy** publicly and get its URL (enable GitHub Pages on
      `docs/`, or equivalent). Needed for the App content form below.
- [ ] **Fill the real contact email** in `docs/privacy-policy.html`,
      `docs/delete-account.html`, and the listing (placeholders remain).
- [ ] Confirm **Supabase project data region** and **email-confirmation** setting
      (dashboard) match what the privacy policy states.

---

## 1. App setup (one-time, App dashboard)
- [ ] Create the app: default language, app name **learn1000words**, "App", "Free".
- [ ] **Store settings** → app category **Education**; add tags.
- [ ] **Contact details** → support email (+ website/phone if any).

## 2. Store listing (Grow → Store presence → Main store listing)
- [ ] Short & full description — copy from `store/play_store_listing.md`
      (short = 78 chars, full ≈ 1,540 chars). Confirm the shipped word count
      before making any "1000 words" quantity claim (see that file's notes).
- [ ] App icon → upload `store/graphics/icon_512.png`.
- [ ] Feature graphic → upload `store/graphics/feature_graphic_1024x500.png`.
- [ ] **Phone screenshots** (2–8, you're providing these — min 320px, 16:9 or 9:16).
- [ ] (Optional) 7-inch / 10-inch tablet screenshots if targeting tablets.
- [ ] Do **not** mention Apple sign-in (Android-gated off — see listing notes).

## 3. App content (Policy → App content) — declarations
- [ ] **Privacy policy** → paste the hosted URL (from Blocker §0).
- [ ] **Ads** → **No** (no ad SDKs — confirmed in data safety inventory).
- [ ] **App access** → all functionality needs a login. Provide **test
      credentials** (a demo email/password account) so review can sign in.
- [ ] **Content ratings** questionnaire → category Education; no violence/
      sexual/gambling content → expect **Everyone / PEGI 3**.
- [ ] **Target audience & content** → choose age groups. If **not** targeting
      children, say so (avoids Families policy obligations).
- [ ] **Data safety** form — fill from `store/data_safety_inventory.md`:
  - Collects & transmits: **Email address**, **Name/nickname** (user-visible),
    **App activity** (progress: level, memorized words/count, streak, friends).
  - Data is **encrypted in transit**; users **can request deletion** (in-app +
    web path). Provide the deletion URL / mechanism.
  - **No** advertising/analytics/tracking; data **not** sold or shared with
    third parties for their own use.
  - Match "shared with other users" rows (nickname, avatar, active pair, level,
    memorized count are visible to friends/search) to the form's sharing questions.
- [ ] **Government apps**, **Financial features**, **Health** → No.
- [ ] **News app** → No.

## 4. Production release (Release → Production, or test track first)
- [ ] **Recommended:** upload to **Internal testing** first, install from the Play
      link on a real device, smoke-test sign-in + sync, then promote to Production.
- [ ] Upload `app-release.aab`. Accept Play App Signing enrollment.
- [ ] Write **release notes** for v1.0.0.
- [ ] **Countries/regions** → select distribution countries.
- [ ] Confirm **Free** pricing (can't switch paid→free later).
- [ ] Roll out (consider a **staged rollout** %).

## 5. After submission
- [ ] Watch **Publishing overview** for review status; resolve any policy flags.
- [ ] Once live, verify install from the public Play listing on a clean device.

---

_Version for this release: `1.0.0+1` (deliberately confirmed). Next release must
bump `versionCode` (the `+N`) — Play rejects a reused code._
