# Pocket Swarm — Game Design Document

## Concept

A survivors-lite mobile game. One thumb, 90 seconds per run, landscape.
Kill enemies, collect XP, pick upgrades, survive, beat the boss.

## Core Loop

```
Move (drag anywhere) → Auto-attack nearest enemy → Enemies drop XP gems
     → Collect gems → Level up → Pick 1 of 3 upgrades → Loop
     → Boss spawns at 90s → Beat boss = win the run
```

## Controls

- **Virtual joystick:** Touch anywhere on screen to spawn a joystick at that point. Drag to move. Release to stop.
- **No buttons needed:** Attack is automatic, targeting the nearest enemy.
- **Landscape orientation locked.**

## Player Character

| Attribute | Base Value | Notes |
|-----------|-----------|-------|
| HP | 100 | Shown as HUD bar |
| Move speed | 200 px/s | Upgradeable |
| Attack damage | 10 | Upgradeable |
| Attack rate | 1 shot/s | Upgradeable (fire rate) |
| Attack range | 150 px | Fixed |
| Pickup radius | 50 px | Upgradeable |
| HP regen | 0/s | Upgradeable |

The player is represented as a simple colored circle/sprite. Visual can be upgraded later — ship with primitives first.

## Enemies

### Regular Enemies

- Spawn from screen edges, steer toward player.
- HP: scales with wave (base 15, +5 per wave).
- Damage on contact: 10/s.
- Speed: 60–100 px/s (random per enemy).
- Drop 1 XP gem on death.

### Spawn Waves

| Time | Wave | Enemies/sec | Enemy HP |
|------|------|-------------|----------|
| 0–15s | 1 | 1.0 | 15 |
| 15–30s | 2 | 1.5 | 20 |
| 30–45s | 3 | 2.0 | 25 |
| 45–60s | 4 | 3.0 | 30 |
| 60–75s | 5 | 4.0 | 35 |
| 75–90s | 6 | 5.0 | 40 |

### Boss

- Spawns at 90 seconds. All regular spawning stops.
- HP: 500
- Speed: 40 px/s (slow but tanky)
- Damage on contact: 20/s
- Size: 3× regular enemy
- Drops nothing — killing the boss wins the run.

## XP & Leveling

| Level | XP Required | Cumulative |
|-------|-------------|------------|
| 2 | 5 | 5 |
| 3 | 10 | 15 |
| 4 | 15 | 30 |
| 5 | 25 | 55 |
| 6 | 40 | 95 |
| 7+ | +20 per level | — |

- XP gems are magnetic — they drift toward the player when within pickup radius.
- Gems give 1 XP each.

## Upgrades

On level-up, the game pauses and shows 3 random upgrades from this pool:

| Upgrade | Effect | Max Stacks |
|---------|--------|------------|
| Damage Up | +5 damage per attack | 5 |
| Fire Rate Up | +0.2 attacks/sec | 5 |
| Move Speed Up | +30 px/s move speed | 3 |
| Pickup Radius Up | +25 px pickup radius | 3 |
| HP Regen | +2 HP/s regen | 5 |
| Max HP Up | +25 max HP (and heal 25) | 3 |

Rules:
- Never offer a maxed-out upgrade.
- Always offer exactly 3 choices (if pool has 3+ available).
- If fewer than 3 remain, offer what's left.
- Selection is random, no weighting for now.

## Weapon (Auto-Attack)

- Projectile fires toward nearest enemy within range.
- Projectile speed: 400 px/s.
- Projectile is a simple shape (small circle or line).
- Projectile despawns on hit or after 2 seconds.
- One projectile at a time per fire interval (no burst).

## Screens & UI

### HUD (during Run)
- **HP bar** — top-left, horizontal bar.
- **XP bar** — top-center, shows progress to next level.
- **Timer** — top-right, counts up to 90s.
- **Level indicator** — next to XP bar, shows current level number.

### Level-Up Overlay
- Pauses gameplay.
- Shows 3 upgrade cards (name + short description).
- Tap one to select and resume.

### Game Over Screen
- "You Survived X seconds"
- "Best: X seconds"
- "Restart" button.

### Win Screen
- "Boss Defeated!"
- "Time: X seconds"
- "Restart" button.

### Title Screen (optional for v1)
- "Pocket Swarm" title.
- "Play" button.
- Can be skipped in v1 — go straight to Run.

## Debug Overlay

- Toggled by **triple-tap** anywhere.
- Shows: FPS, enemy count, current wave, player position.
- Semi-transparent, bottom-right corner.
- Only in debug/dev builds (can strip for release).

## Save Data

Minimal — stored via Godot's `ConfigFile` or `FileAccess`:

- `best_time` — longest survival time in seconds.
- `best_level` — highest level reached.
- `runs_played` — total run count.

No cloud save. No accounts. Local only.

## Visual Style

Ship with **primitives** (colored shapes):
- Player: blue circle
- Enemies: red circles (boss is larger, darker red)
- Projectiles: white small circles
- XP gems: green small diamonds
- Background: dark gray

This is intentionally minimal. Art can be layered on later without changing any game logic.

## Audio (optional for v1)

Not required for initial build. Can add later:
- Simple SFX: shoot, hit, pickup, level-up chime, death.
- Background loop: optional.
