# Pocket Swarm — Build Contract

## Project Summary

**Title:** Pocket Swarm *(working title — not final)*
**Engine:** Godot 4.6 (GDScript only — no C#)
**Orientation:** Landscape 16:9, safe-area aware
**Platforms:** iOS + Android
**Monetization:** Free with ads
**Genre:** Survivors-lite (auto-attack, swarm survival, upgrade loop, meta-progression)

## Non-Negotiable Acceptance Tests

Every build must pass all six before it ships:

| # | Test | Pass Criteria |
|---|------|---------------|
| 1 | **Performance** | 60 FPS on a mid-range device with 200 enemies on screen. |
| 2 | **One-thumb control** | Virtual joystick works from any touch origin on screen — no dead zones, no edge failures. |
| 3 | **Level-up offers** | Always presents exactly 3 unique upgrades (unless the remaining pool has fewer than 3). |
| 4 | **Difficulty ramp** | Enemy spawn rate increases every 15 seconds (verifiable via debug overlay). |
| 5 | **No softlocks** | From any state (game over, boss killed, level-up panel open, paused) the player can restart a new run. |
| 6 | **App lifecycle** | Pause/resume (home button, phone call, lock screen) does not break the run — state is preserved. |

## Manual Verification Checklist

Run through this after every significant change:

- [ ] Fresh install on device — launches without crash
- [ ] Play a full 99-second run to boss spawn
- [ ] Die to enemies — Game Over screen appears, restart works
- [ ] Beat the boss — Win screen appears, restart works
- [ ] Level up at least 3 times — each offers 3 unique choices
- [ ] Pause mid-run (home button) — resume returns to exact state
- [ ] Toggle debug overlay (triple-tap) — shows FPS + enemy count
- [ ] With 150+ enemies on screen — FPS stays above 55
- [ ] Touch near screen edges — joystick responds correctly
- [ ] Rotate device — layout remains correct (landscape lock)

## Build Targets

| Platform | Format | Min Target |
|----------|--------|------------|
| Android | AAB (Android App Bundle) | API 35 (Android 15) — required for new Play Store submissions as of Aug 31, 2025 |
| iOS | Xcode project → IPA | iOS 16+ (reasonable floor for App Store) |

## Quality Bar

- No GDScript errors or warnings in the Output panel
- No orphaned nodes or leaked references
- All scenes load without missing dependencies
- Export to both platforms completes without errors
- Ad SDK initializes without crash on both platforms
- Sprite assets load correctly (no missing texture errors)
