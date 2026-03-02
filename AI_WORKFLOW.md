# Pocket Swarm — AI Development Workflow

## Principle

Don't ask the AI to "make a game." Give it a **contract + acceptance tests**, then let it patch until green. Each iteration is small, testable, and reversible.

---

## Phase 1: Repo Generation

Give the AI this prompt (adapt as needed):

> Create a Godot 4.6 project named PocketSwarm.
> - Use GDScript only.
> - Landscape 16:9; safe-area aware.
> - Scenes: Main.tscn (boot/scene switch), TitleScreen.tscn (menu), Run.tscn (gameplay), LevelUp.tscn (overlay), GameOver.tscn, Armory.tscn (equipment shop).
> - Systems: Spawner (wave ramp, boss at 99s), Enemy (steer to player), Weapon (auto-target nearest, multiple weapon types), XP (gems + leveling), Coins (meta currency), Upgrades (pool + weapon-specific paths), Loadout (weapon/armor/ship selection), Save (stats, coins, unlocks, loadout), Ads (interstitial + rewarded via AdMob).
> - Include a debug overlay toggled by triple-tap showing FPS, enemy count.
> - Provide all scripts and .tscn files with full contents.
> - Provide a minimal CI-style script/checklist for manual verification.

Expected output: a complete set of `.tscn` and `.gd` files that can be dropped into a Godot project and run.

---

## Phase 2: Iteration Loop

### The Rule

**AI may only change what's failing.** No rewrites. No "while I'm here" improvements.

### Each Cycle

```
1. You run the game (editor or export)
2. Observe: crash? bug? test failure?
3. Paste the exact issue back to AI:
   - Crash log / error message
   - Steps to reproduce
   - Which acceptance test it violates
4. AI returns a MINIMAL diff:
   - File → change summary → exact edits
   - No changes to passing systems
5. Apply the diff, re-test
6. Repeat until all 6 acceptance tests pass
```

### Prompt Template for Bug Reports

```
The following acceptance test is failing:
[Test #X: description]

Observed behavior:
[What actually happens]

Expected behavior:
[What should happen]

Error log (if any):
[Paste from Godot output panel]

Fix ONLY this issue. Do not modify any other files or systems.
Return: file path → change summary → exact code edits.
```

---

## Phase 3: Polish & Export

Once all acceptance tests pass:

1. **Performance pass:** Run with debug overlay, verify 60 FPS at 200 enemies.
2. **Art pass:** Integrate provided sprite art and audio assets.
3. **Ad pass:** Integrate AdMob SDK, test interstitial + rewarded flows.
4. **Export pass:** Set up Android and iOS export presets (see PUBLISHING.md).
5. **Test on device:** Internal testing (Play) / TestFlight (iOS).

---

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Bad | Instead |
|-------------|-------------|---------|
| "Make the game" (one big prompt) | AI loses coherence over large outputs | Break into contract + iterative patches |
| AI rewrites passing code | Reintroduces bugs | Enforce "only fix what's failing" rule |
| No acceptance tests | No way to know if it's done | Define tests upfront in BUILD.md |
| Skipping device testing | Editor ≠ phone performance | Always test exports on real devices |
| Changing scope mid-iteration | Moving goalposts = infinite loop | Lock scope, ship, then iterate |

---

## Prompt Hygiene

### Do
- Be specific: file names, line numbers, exact error text.
- One issue per prompt.
- Reference the acceptance test number.
- Ask for minimal diffs, not full file rewrites.

### Don't
- Paste the entire project and say "fix it."
- Ask for multiple unrelated changes at once.
- Let the AI add features you didn't ask for.
- Accept changes without testing them.

---

## Milestone Checklist

### M1: Playable Core
- [ ] Player moves with virtual joystick
- [ ] Enemies spawn and chase player
- [ ] Auto-attack kills enemies
- [ ] XP gems drop and can be collected
- [ ] Runs in editor without crashes

### M2: Game Loop Complete
- [ ] Level-up triggers with 3 upgrade choices
- [ ] Upgrades apply correctly to player stats
- [ ] Boss spawns at 99s
- [ ] Game over on player death
- [ ] Win on boss kill
- [ ] Restart works from both end states
- [ ] Coins drop and are collected
- [ ] Coins persist after run ends

### M3: Meta-Progression
- [ ] Title screen with Play + Armory buttons
- [ ] Armory screen shows weapons/armor/ships
- [ ] Locked/unlocked/equipped states display correctly
- [ ] Purchasing with coins works
- [ ] Equipped loadout applies to run (weapon type, armor bonus, ship sprite)
- [ ] Save system persists all unlocks and loadout
- [ ] Discovery system hides undiscovered items as "???"

### M4: Art & Audio
- [ ] All sprite art integrated (player ships, enemies, projectiles, pickups, UI)
- [ ] All audio integrated (SFX + music)
- [ ] No missing texture or audio errors

### M5: Polish & Tests
- [ ] All 6 acceptance tests pass
- [ ] Debug overlay works (triple-tap)
- [ ] Save system persists stats, coins, unlocks, loadout
- [ ] HUD shows all required info (HP, XP, timer, coins, level)
- [ ] No GDScript errors or warnings

### M6: Ads & Export
- [ ] AdMob SDK integrated
- [ ] Interstitial ad shows on game over / win
- [ ] Rewarded ad for 2× coins works
- [ ] Android AAB exports cleanly
- [ ] iOS Xcode project exports cleanly
- [ ] Tested on real Android device
- [ ] Tested on real iOS device

### M7: Publish
- [ ] Privacy policy live (discloses ad data)
- [ ] Store listings prepared
- [ ] Submitted to both stores

---

## File Change Log Convention

When the AI makes changes, have it report in this format:

```
## Change Set [date/number]
Fixing: Acceptance Test #X — [description]

### scripts/spawner.gd
- Lines 42-45: Changed spawn interval calculation to use wave multiplier
- Added: `_get_spawn_rate()` helper function

### scenes/Run.tscn
- No changes

### Summary
- 1 file changed, 6 lines modified
- Test #X should now pass
- No other systems affected
```

This creates a reviewable audit trail and prevents scope creep.
