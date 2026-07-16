---
name: verify
description: How to build, launch and drive learn1000words on the Android emulator to verify changes end-to-end.
---

# Verifying learn1000words on the emulator

## Build & launch
- Flutter SDK is in-repo: `C:\Users\ermel\wa\learn1000words\flutter\bin\flutter.bat` (fresh shells may lack it on PATH).
- adb: `%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe`. Emulator AVD: `pixel_api36` (boot with `%LOCALAPPDATA%\Android\Sdk\emulator\emulator.exe -avd pixel_api36` if `adb devices` is empty).
- Run: `flutter.bat run -d emulator-5554` in the background; ready when the log prints "Flutter run key commands".
- Fresh state: `adb shell pm clear com.ermellino.learn1000words` (re-triggers onboarding: nickname → avatar → language pair → daily goal).

## Driving the UI
- Screenshots: `adb shell screencap -p /sdcard/s.png` + `adb pull` (PowerShell `>` corrupts binary output — never redirect).
- The Read tool displays screenshots scaled (e.g. 900x2000 for the 1080x2400 device); multiply displayed coords by the stated factor for `input tap`.
- Before `input text`: `adb shell settings put secure stylus_handwriting_enabled 0` (restore to 1 after) or the handwriting tutorial overlay swallows taps.
- `input text` is ASCII-only. For accented letters (á í ő …) drive Gboard's long-press popup with raw motion events:
  1. `input motionevent DOWN <x> <y>` on the base key, sleep ~0.9s
  2. screenshot to locate the accent in the popup
  3. `input motionevent MOVE <x> <y>` to it, then `input motionevent UP <x> <y>`
- Tapping a Material button while the keyboard is up: recompute its Y — the layout shrinks.

## Flows worth driving
- Level 1 → Flashcard (In ordine / Casuale, tap to flip, swipe/arrows to advance).
- Level 1 → Test: segmented per-letter field; wrong answer "haz" for ház shows red middle cell + solution; correct answers mark memorized. Placeholder dataset is 2 words/level (casa→ház, acqua→víz), so completing level 1 (unlocks level 2) takes two correct answers.
- Known Words: per-level from Level Detail, global from the "Parole" tab (searchable).

## Inspecting state
- Device DB: `adb shell "run-as com.ermellino.learn1000words sqlite3 /data/data/com.ermellino.learn1000words/app_flutter/learn1000words.sqlite 'SQL'"` — tables `word_progress` (word_id, status, memorized_at) and `profiles` (memorized_count). Drift streams don't see external writes; force-stop + relaunch to observe them.
