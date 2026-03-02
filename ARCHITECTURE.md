# Pocket Swarm — Technical Architecture

## Engine & Language

- **Godot 4.x** (latest stable)
- **GDScript only** — no C#, no GDExtension
- Reason: C# iOS export is experimental; GDScript is the safest path for dual-platform mobile.

## Project Structure

```
PocketSwarm/
├── project.godot
├── export_presets.cfg
├── icon.svg
│
├── scenes/
│   ├── Main.tscn              # Boot scene, handles scene switching
│   ├── Run.tscn               # Core gameplay scene
│   ├── LevelUp.tscn           # Upgrade selection overlay (CanvasLayer)
│   └── GameOver.tscn          # Game over / win screen
│
├── scripts/
│   ├── main.gd                # Scene manager, global state reset
│   ├── player.gd              # Movement, HP, stats, collision
│   ├── weapon.gd              # Auto-targeting, projectile spawning
│   ├── projectile.gd          # Movement, hit detection, despawn
│   ├── enemy.gd               # Steering toward player, damage
│   ├── boss.gd                # Boss variant (extends enemy logic)
│   ├── spawner.gd             # Wave management, spawn timing
│   ├── xp_gem.gd              # Gem behavior, magnetic pickup
│   ├── xp_manager.gd          # XP tracking, level-up trigger
│   ├── upgrade_manager.gd     # Upgrade pool, random selection, application
│   ├── hud.gd                 # HP bar, XP bar, timer, level display
│   ├── level_up_ui.gd         # 3-card selection UI
│   ├── game_over_ui.gd        # End screen logic
│   ├── save_manager.gd        # Local save/load (ConfigFile)
│   ├── debug_overlay.gd       # FPS, enemy count, triple-tap toggle
│   └── virtual_joystick.gd    # Touch-anywhere joystick input
│
├── resources/
│   └── (placeholder textures, if any)
│
└── addons/
    └── (none initially)
```

## Scene Tree Design

### Main.tscn
```
Main (Node)
└── (loads Run.tscn or GameOver.tscn as child)
```

### Run.tscn
```
Run (Node2D)
├── Player (CharacterBody2D)
│   ├── CollisionShape2D
│   ├── Sprite2D (or ColorRect placeholder)
│   └── Weapon (Node2D)
│       └── FireTimer (Timer)
├── Spawner (Node)
│   └── SpawnTimer (Timer)
├── Enemies (Node2D)              # Parent for all enemy instances
├── Projectiles (Node2D)          # Parent for all projectile instances
├── XPGems (Node2D)               # Parent for all gem instances
├── XPManager (Node)
├── UpgradeManager (Node)
├── HUD (CanvasLayer)
│   ├── HPBar (ProgressBar)
│   ├── XPBar (ProgressBar)
│   ├── LevelLabel (Label)
│   └── TimerLabel (Label)
├── LevelUpUI (CanvasLayer)       # Hidden until level-up
│   ├── Panel
│   └── UpgradeCards (HBoxContainer)
│       ├── Card1 (Button)
│       ├── Card2 (Button)
│       └── Card3 (Button)
├── DebugOverlay (CanvasLayer)    # Hidden by default
│   └── DebugLabel (Label)
└── VirtualJoystick (CanvasLayer) # Touch input processing
```

### GameOver.tscn
```
GameOver (CanvasLayer)
├── Panel
│   ├── TitleLabel ("Game Over" or "Boss Defeated!")
│   ├── StatsLabel (time survived, level reached)
│   ├── BestLabel (best time)
│   └── RestartButton
```

## System Responsibilities

### Player (`player.gd`)
- Reads joystick input → `move_and_slide()`.
- Tracks: HP, max HP, move speed, pickup radius, HP regen.
- Applies HP regen each frame.
- Detects collision with enemies (damage over time on contact).
- Emits `died` signal.

### Weapon (`weapon.gd`)
- Attached to Player.
- Each fire interval: find nearest enemy in range → spawn projectile toward it.
- Tracks: damage, fire rate (attacks/sec).
- No input needed — fully automatic.

### Projectile (`projectile.gd`)
- Moves in a straight line at constant speed.
- On collision with enemy: deal damage, `queue_free()`.
- Despawns after 2 seconds (TTL timer).

### Enemy (`enemy.gd`)
- Steers toward player position each frame.
- On overlap with player: deal contact damage.
- Tracks HP; emits `died` signal when HP ≤ 0.
- On death: spawn XP gem at position, `queue_free()`.

### Boss (`boss.gd`)
- Same as Enemy but: higher HP, larger collision, slower speed, higher damage.
- On death: emit `boss_defeated` signal → trigger win.

### Spawner (`spawner.gd`)
- Manages wave progression (wave number, enemies/sec).
- Every 15 seconds: increment wave, increase spawn rate.
- Spawns enemies at random points just outside the visible screen.
- At 90 seconds: stop spawning regulars, spawn the boss.

### XP Gem (`xp_gem.gd`)
- Sits on the ground after enemy death.
- When player is within pickup radius: lerp toward player.
- On overlap with player: add XP, `queue_free()`.

### XP Manager (`xp_manager.gd`)
- Tracks current XP, current level, XP threshold for next level.
- On threshold reached: emit `level_up` signal → pause tree, show LevelUpUI.

### Upgrade Manager (`upgrade_manager.gd`)
- Holds the full upgrade pool with max stacks.
- On `level_up`: pick 3 random non-maxed upgrades.
- On selection: apply stat change to player/weapon, decrement remaining stacks.

### HUD (`hud.gd`)
- Updates HP bar, XP bar, level label, timer every frame.
- Pure display — no game logic.

### Save Manager (`save_manager.gd`)
- Autoload singleton.
- Uses `ConfigFile` for persistence.
- Saves: best_time, best_level, runs_played.
- Loads on startup, saves on run end.

### Virtual Joystick (`virtual_joystick.gd`)
- Listens to `InputEventScreenTouch` and `InputEventScreenDrag`.
- On touch: record origin point.
- On drag: calculate direction vector from origin to current touch.
- On release: zero out direction.
- Exposes `direction: Vector2` for Player to read.

### Debug Overlay (`debug_overlay.gd`)
- Tracks tap count + timing for triple-tap detection.
- When visible: updates label with FPS, enemy count, wave, player pos.

## Performance Considerations

Target: 200 enemies at 60 FPS on a mid-range phone.

- **Object pooling:** Consider pooling enemies and projectiles if `queue_free()` / `instantiate()` causes GC spikes.
- **Physics layers:** Use separate collision layers for player-vs-enemy, projectile-vs-enemy, player-vs-gem. Avoid unnecessary collision checks.
- **Enemy steering:** Simple `(player.position - position).normalized()` — no pathfinding needed.
- **Projectile cleanup:** TTL timer prevents projectile buildup.
- **Node count:** Keep the Enemies/Projectiles/XPGems containers flat (no deep nesting).

## Collision Layers

| Layer | Name | Used By |
|-------|------|---------|
| 1 | Player | Player body |
| 2 | Enemies | Enemy bodies |
| 3 | Projectiles | Projectile areas |
| 4 | XP Gems | Gem pickup areas |
| 5 | Pickup Zone | Player's pickup radius area |

| Interaction | Mask |
|------------|------|
| Player ↔ Enemy | Player checks layer 2 |
| Projectile → Enemy | Projectile checks layer 2 |
| Pickup Zone → Gem | Pickup checks layer 4 |

## Display & Safe Area

- **Viewport:** 1920×1080 (landscape 16:9)
- **Stretch mode:** `canvas_items`
- **Stretch aspect:** `expand`
- **Safe area:** Use `DisplayServer.get_display_safe_area()` to inset HUD elements away from notches/rounded corners.

## Autoloads

| Name | Script | Purpose |
|------|--------|---------|
| SaveManager | `save_manager.gd` | Persistent data |

Keep autoloads minimal. Most systems live in the Run scene.

## Input Map

No custom input actions needed. All input is touch-based, handled directly via `_input()` or `_unhandled_input()`.

## Signals Flow

```
Player.died           → Run: trigger game over
Enemy.died            → Spawner: decrement count; XP: spawn gem
Boss.boss_defeated    → Run: trigger win screen
XPManager.level_up    → Run: pause, show LevelUpUI
LevelUpUI.selected    → UpgradeManager: apply upgrade, unpause
RestartButton.pressed → Main: reload Run scene
VirtualJoystick       → Player reads direction each frame (polling, not signal)
```
