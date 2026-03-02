extends Node
## Manages enemy wave progression. Spawns enemies off-screen, boss at 99s.

signal boss_spawned

const BOSS_TIME := 99.0
const WAVE_DURATION := 15.0
const SPAWN_MARGIN := 50.0

var _enemy_scene: PackedScene = preload("res://scenes/Enemy.tscn")
var _elapsed: float = 0.0
var _wave: int = 1
var _spawn_accumulator: float = 0.0
var _boss_spawned := false

@onready var _enemies: Node2D = $"../Enemies"
@onready var _xp_gems: Node2D = $"../XPGems"
@onready var _player: CharacterBody2D = $"../Player"
@onready var _spawn_timer: Timer = $SpawnTimer

# Wave table: [enemies_per_sec, enemy_hp]
var _wave_table: Array[Array] = [
	[1.0, 15.0],   # Wave 1: 0–15s
	[1.5, 20.0],   # Wave 2: 15–30s
	[2.0, 25.0],   # Wave 3: 30–45s
	[3.0, 30.0],   # Wave 4: 45–60s
	[4.0, 35.0],   # Wave 5: 60–75s
	[5.0, 40.0],   # Wave 6: 75–99s
]

func _ready() -> void:
	_spawn_timer.wait_time = 0.1
	_spawn_timer.timeout.connect(_on_spawn_tick)
	_spawn_timer.start()

func _on_spawn_tick() -> void:
	if _boss_spawned:
		return
	_elapsed += _spawn_timer.wait_time
	# Update wave
	_wave = clampi(int(_elapsed / WAVE_DURATION) + 1, 1, _wave_table.size())
	# Check boss time
	if _elapsed >= BOSS_TIME:
		_spawn_boss()
		return
	# Accumulate spawn budget
	var wave_data: Array = _wave_table[_wave - 1]
	var enemies_per_sec: float = wave_data[0]
	_spawn_accumulator += enemies_per_sec * _spawn_timer.wait_time
	while _spawn_accumulator >= 1.0:
		_spawn_accumulator -= 1.0
		_spawn_enemy(wave_data[1])

func _spawn_enemy(hp: float) -> void:
	var enemy: CharacterBody2D = _enemy_scene.instantiate()
	enemy.global_position = _get_offscreen_position()
	enemy.max_hp = hp
	enemy.hp = hp
	enemy.init(_player)
	enemy.died.connect(_on_enemy_died)
	_enemies.add_child(enemy)

func _spawn_boss() -> void:
	_boss_spawned = true
	_spawn_timer.stop()
	boss_spawned.emit()
	# Boss is handled by Run scene — emit signal and let it spawn the boss node

func _on_enemy_died(enemy: CharacterBody2D) -> void:
	_drop_xp_gem(enemy.global_position, enemy.xp_value)

func _drop_xp_gem(pos: Vector2, value: int) -> void:
	var gem_scene: PackedScene = preload("res://scenes/XPGem.tscn")
	var gem: Area2D = gem_scene.instantiate()
	gem.global_position = pos
	gem.init(_player, value)
	_xp_gems.add_child(gem)

func _get_offscreen_position() -> Vector2:
	var vp_size := get_viewport().get_visible_rect().size
	var cam_pos := _player.global_position
	var half := vp_size / 2.0
	var side := randi() % 4
	var pos := Vector2.ZERO
	match side:
		0: # top
			pos.x = cam_pos.x + randf_range(-half.x, half.x)
			pos.y = cam_pos.y - half.y - SPAWN_MARGIN
		1: # bottom
			pos.x = cam_pos.x + randf_range(-half.x, half.x)
			pos.y = cam_pos.y + half.y + SPAWN_MARGIN
		2: # left
			pos.x = cam_pos.x - half.x - SPAWN_MARGIN
			pos.y = cam_pos.y + randf_range(-half.y, half.y)
		3: # right
			pos.x = cam_pos.x + half.x + SPAWN_MARGIN
			pos.y = cam_pos.y + randf_range(-half.y, half.y)
	return pos

func get_wave() -> int:
	return _wave

func get_elapsed() -> float:
	return _elapsed

func get_enemy_count() -> int:
	return _enemies.get_child_count()
