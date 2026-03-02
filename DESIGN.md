# Pocket Swarm — Game Design Document

## Concept

A survivors-lite mobile game. One thumb, 99 seconds per run, landscape.
Kill enemies, collect XP, pick upgrades, survive, beat the boss.
Between runs: spend currency to unlock weapons, armor, and ships.

## Core Loop

```
Move (drag anywhere) → Auto-attack nearest enemy → Enemies drop XP gems + coins
     → Collect gems → Level up → Pick 1 of 3 upgrades → Loop
     → Boss spawns at 99s → Beat boss = win the run
     → Earn coins → Spend in meta shop → Unlock gear → Start new run stronger
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

The player is represented as a sprite. Art will be provided for v1.
The active ship determines the player's base sprite and may modify base stats.

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
| 75–99s | 6 | 5.0 | 40 |

### Boss

- Spawns at 99 seconds. All regular spawning stops.
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

## Weapons (Auto-Attack)

### Default Weapon: Blaster
- Projectile fires toward nearest enemy within range.
- Projectile speed: 400 px/s.
- Projectile despawns on hit or after 2 seconds.
- One projectile at a time per fire interval (no burst).

### Discoverable Weapons (unlocked via meta-progression)

Weapons are unlocked permanently with coins and selected before a run starts.
Only one weapon is active per run. Each weapon has its own upgrade path.

| Weapon | Behavior | Unlock Cost | Notes |
|--------|----------|-------------|-------|
| Blaster | Single shot, nearest enemy | Free (default) | Balanced starter |
| Spread Shot | 3 projectiles in a cone | TBD | Lower per-shot damage, better crowd control |
| Orbitals | Rotating projectiles circle the player | TBD | No aiming, constant area damage |
| Piercer | Shot passes through enemies | TBD | High damage, slow fire rate |

*Exact weapon list and costs are TBD — start with Blaster only for MVP, add others post-M2.*

### Weapon Upgrade Paths (in-run)

When a weapon-specific upgrade appears in the level-up pool, it enhances the current weapon:

| Weapon | Possible In-Run Upgrades |
|--------|--------------------------|
| Blaster | +damage, +fire rate, +projectile speed |
| Spread Shot | +projectile count, +cone width, +damage |
| Orbitals | +orbit count, +orbit speed, +orbit radius |
| Piercer | +pierce count, +damage, +fire rate |

These are added to the general upgrade pool (move speed, HP, etc.) during level-up.

## Screens & UI

### HUD (during Run)
- **HP bar** — top-left, horizontal bar.
- **XP bar** — top-center, shows progress to next level.
- **Timer** — top-right, counts up to 99s.
- **Level indicator** — next to XP bar, shows current level number.
- **Coin counter** — near HP bar, shows coins earned this run.

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

### Title / Menu Screen
- Game title.
- "Play" button → starts run with currently equipped loadout.
- "Armory" button → opens equipment/shop screen.

### Armory Screen (meta-progression hub)
- **Weapons tab:** List of all weapons (locked/unlocked). Tap to equip or buy.
- **Armor tab:** List of all armor sets. Each gives a passive bonus.
- **Ships tab:** List of all ships. Each changes player sprite and may adjust base stats.
- Coin balance shown prominently.
- "Back" returns to title screen.

## Debug Overlay

- Toggled by **triple-tap** anywhere.
- Shows: FPS, enemy count, current wave, player position.
- Semi-transparent, bottom-right corner.
- Only in debug/dev builds (can strip for release).

## Meta-Progression (Between Runs)

### Currency: Coins

- Enemies have a chance to drop coins (separate from XP gems).
- Coins are kept even if you die — they persist across runs.
- Spent in the Armory to unlock weapons, armor, and ships.

### Armor

Armor provides passive bonuses. One armor set equipped at a time.

| Armor | Bonus | Unlock Cost |
|-------|-------|-------------|
| None | — | Free (default) |
| Light Plating | +15 max HP | TBD |
| Heavy Plating | +30 max HP, −10% move speed | TBD |
| Regen Suit | +1 HP/s base regen | TBD |
| Magnet Vest | +30 pickup radius | TBD |

*Exact list and costs TBD — start with no armor for MVP.*

### Ships

Ships change the player's sprite and may modify base stats.

| Ship | Stat Modifier | Unlock Cost |
|------|---------------|-------------|
| Default | None | Free |
| Scout | +20% move speed, −10% max HP | TBD |
| Tank | +30% max HP, −15% move speed | TBD |
| Collector | +50% pickup radius | TBD |

*Exact list and costs TBD — start with default ship for MVP.*

### Discovery

- Some items are visible but locked ("???") until a discovery condition is met.
- Discovery conditions: reach a certain level, survive X seconds, kill X enemies in one run, beat the boss, etc.
- Once discovered, the item becomes visible and purchasable with coins.

## Save Data

Stored via Godot's `ConfigFile` or `FileAccess`:

- `best_time` — longest survival time in seconds.
- `best_level` — highest level reached.
- `runs_played` — total run count.
- `coins` — total coin balance.
- `unlocked_weapons` — list of unlocked weapon IDs.
- `unlocked_armor` — list of unlocked armor IDs.
- `unlocked_ships` — list of unlocked ship IDs.
- `equipped_weapon` — currently selected weapon ID.
- `equipped_armor` — currently selected armor ID.
- `equipped_ship` — currently selected ship ID.
- `discoveries` — list of discovered item IDs.

No cloud save. No accounts. Local only.

## Visual Style

Sprite art will be provided for v1. All game objects use `Sprite2D` nodes.

- Player: sprite determined by equipped ship.
- Enemies: unique sprites per enemy type (regular, boss).
- Projectiles: sprite per weapon type.
- XP gems: small gem sprite.
- Coins: small coin sprite.
- Background: TBD (tiling space/arena texture or flat color).

Art pipeline: sprites provided by the developer, loaded as `.png` in `assets/sprites/`.

## Audio

Audio assets will be provided by the developer. The game should support:

- **SFX:** shoot, enemy hit, enemy death, pickup (gem), pickup (coin), level-up chime, player hit, player death, boss spawn, boss defeated, UI button tap.
- **Music:** background loop during run (can be a single track for MVP).
- Audio files placed in `assets/audio/sfx/` and `assets/audio/music/`.
- Volume should respect device silent mode / ringer switch.
- Optional: mute toggle in title screen (save preference).

## Ads

**Model:** Free with ads.

- **Interstitial ad:** Shown on Game Over / Win screen before the restart button is available. Skippable after a delay.
- **Optional rewarded ad:** "Watch ad for 2× coins" on the results screen. Player can skip.
- **No banner ads during gameplay** — they would obstruct the play area.
- Ad SDK: TBD (AdMob is the standard choice for Godot mobile).
- Ad integration is a post-MVP task — get the game working first, add ads last.
- Privacy policy must disclose ad data collection (see PUBLISHING.md).
