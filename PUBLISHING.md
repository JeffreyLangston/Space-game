# Pocket Swarm — Store Publishing Guide

## Overview

Two stores, two pipelines, two sets of blockers. This doc covers what's needed beyond the code.

---

## Android (Google Play)

### Requirements

| Requirement | Detail |
|-------------|--------|
| **Target API** | API 35 (Android 15) — mandatory for new apps as of Aug 31, 2025 |
| **Package format** | AAB (Android App Bundle) — APK not accepted for new submissions |
| **Signing** | Upload keystore (you generate); Google manages app signing key |
| **Min SDK** | API 24 (Android 7.0) is a reasonable floor |

### Godot Export Setup

1. Install Android build template in Godot: `Project > Install Android Build Template`.
2. Set export preset:
   - Format: AAB
   - Min SDK: 24
   - Target SDK: 35
   - Package name: `com.yourname.pocketswarm`
   - Version code: 1 (increment each upload)
   - Version name: `1.0.0`
3. Keystore:
   - Generate: `keytool -genkey -v -keystore pocket-swarm.keystore -alias upload -keyalg RSA -keysize 2048 -validity 10000`
   - Configure path + passwords in Godot export settings.
   - **Never commit the keystore to the repo.**

### Play Console Setup

Developer account: **already exists.**

- [ ] Create app listing in Play Console
- [ ] Fill in: title, description, category (Casual/Action), content rating questionnaire
- [ ] Upload screenshots (landscape): phone + tablet (min 2 each)
- [ ] Set pricing: Free
- [ ] Set up AdMob app ID and link to Play Console
- [ ] Privacy policy URL (required — must disclose ad SDK data collection)
- [ ] Data safety form (declare: ad SDK collects device identifiers, ad interaction data; no user-provided data collected)
- [ ] Upload AAB to internal testing track first
- [ ] Test on 3+ devices via internal testing
- [ ] Promote to production

### Android Gotchas

- Target API 35 means you must test against Android 15 behavior changes (predictive back gesture, edge-to-edge enforcement).
- Godot's Android export must use a compatible Gradle version — check Godot release notes.
- First submission review can take 1–7 days.
- Keep app size under 150 MB for AAB (Pocket Swarm should be well under).

---

## iOS (App Store)

### Requirements

| Requirement | Detail |
|-------------|--------|
| **Xcode** | Latest stable (requires macOS) |
| **Deployment target** | iOS 16+ recommended |
| **Signing** | Apple Developer certificate + provisioning profile |
| **Format** | IPA via Xcode archive, uploaded via Transporter or Xcode |

### Godot Export Setup

1. Export from Godot as Xcode project (not direct IPA).
2. Export preset:
   - Bundle identifier: `com.yourname.pocketswarm`
   - Team ID: your Apple Developer team ID
   - Version: `1.0.0`
   - Build number: 1
   - Deployment target: 16.0
   - Landscape left + landscape right orientations only
3. Open generated Xcode project on a Mac.
4. In Xcode:
   - Select your signing team
   - Set capabilities (none needed for this game)
   - Archive → Upload to App Store Connect

### App Store Connect Setup

Developer account: **already exists.** Mac available for Xcode builds.

- [ ] Create app record in App Store Connect
- [ ] Fill in: name, subtitle, description, keywords, category (Games > Action)
- [ ] Upload screenshots (landscape): iPhone 6.7", iPhone 6.5", iPad Pro 12.9"
- [ ] App icon: 1024×1024 PNG (no alpha, no rounded corners — Apple rounds them)
- [ ] Privacy policy URL (must disclose ad SDK data collection)
- [ ] App Review information (demo notes if needed)
- [ ] Age rating questionnaire
- [ ] App Tracking Transparency: required if AdMob uses IDFA — add ATT prompt
- [ ] Upload build via Xcode/Transporter
- [ ] Submit for review

### iOS Gotchas

- **"Thin app" rejections:** Apple rejects apps that feel too simple or demo-like. The game needs to feel complete: working gameplay loop, sprite art, audio, meta-progression, no placeholder text.
- **Safe area:** iPhones with notch/Dynamic Island — HUD must respect safe area insets.
- **No hot-code loading:** All code must be bundled at build time (GDScript is fine).
- **Provisioning profiles:** Expire; set a reminder to renew.
- **Review time:** Usually 24–48 hours, can be longer for first submission.
- **No JIT:** Godot's GDScript interpreter is fine; this restriction affects other engines more.

---

## Shared Assets Needed

### Before Either Submission

| Asset | Spec | Notes |
|-------|------|-------|
| App icon | 1024×1024 PNG | Used by both stores; iOS requires no alpha |
| Feature graphic | 1024×500 PNG | Android Play Store listing header |
| Screenshots | Landscape, per-device sizes | At least 2 per required device class |
| Privacy policy | Hosted URL | Must disclose ad SDK data collection (device ID, ad interaction). Can be GitHub Pages or Notion |
| Short description | 80 chars max | Play Store |
| Full description | 4000 chars max | Both stores |

### Icon Ideas (AI-generable)

- Simple: dark background, stylized swarm of red dots converging on a blue dot.
- Can generate with any image AI tool, then resize to 1024×1024.

---

## What AI Can Do vs. What Requires a Human

| Task | AI? | Human? |
|------|-----|--------|
| Write all game code | Yes | — |
| Generate export presets | Yes | — |
| Generate app icon / splash | Yes | — |
| Write store descriptions | Yes | — |
| Write privacy policy (with ad disclosure) | Yes | — |
| Integrate ad SDK code | Yes | — |
| Create developer accounts | — | Already done |
| Generate signing certs/keystores | — | Yes |
| Provide sprite art | — | Yes |
| Provide audio assets | — | Yes |
| Upload builds | — | Yes |
| Fill compliance forms (data safety, ATT) | — | Yes (account-gated) |
| Take device screenshots | — | Yes (or automated via device farm) |
| Respond to review rejections | — | Yes |

---

## Release Checklist

### Pre-submission
- [ ] All 6 acceptance tests pass (see BUILD.md)
- [ ] Debug overlay is disabled/stripped in release build
- [ ] App icon is set in project.godot
- [ ] Version number is correct
- [ ] No console errors or warnings
- [ ] Ad SDK integrated and tested (interstitial + rewarded)
- [ ] All sprite art and audio assets are final
- [ ] Privacy policy URL is live and discloses ad data collection

### Android
- [ ] AAB builds without errors
- [ ] Tested on internal testing track
- [ ] Target SDK = 35
- [ ] Keystore is backed up securely (NOT in repo)

### iOS
- [ ] Xcode project exports from Godot
- [ ] Xcode archive succeeds
- [ ] Tested on TestFlight
- [ ] Signing and provisioning are valid
- [ ] Safe area tested on notched device
