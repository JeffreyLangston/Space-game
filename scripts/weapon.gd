extends Node2D
## Auto-targeting weapon. Fires projectiles at the nearest enemy.

@export var damage: float = 10.0
@export var fire_rate: float = 2.0  # shots per second
@export var attack_range: float = 300.0

var _projectile_scene: PackedScene = preload("res://scenes/Projectile.tscn")

@onready var _fire_timer: Timer = $FireTimer
@onready var _enemies_container: Node2D = $"../../Enemies"
@onready var _projectiles_container: Node2D = $"../../Projectiles"

func _ready() -> void:
	_fire_timer.wait_time = 1.0 / fire_rate
	_fire_timer.timeout.connect(_on_fire)
	_fire_timer.start()

func _on_fire() -> void:
	var target := _find_nearest_enemy()
	if target == null:
		return
	var proj: Area2D = _projectile_scene.instantiate()
	proj.global_position = global_position
	proj.setup(global_position.direction_to(target.global_position), damage)
	_projectiles_container.add_child(proj)

func _find_nearest_enemy() -> Node2D:
	var best: Node2D = null
	var best_dist := attack_range
	for enemy in _enemies_container.get_children():
		if not is_instance_valid(enemy):
			continue
		var dist := global_position.distance_to(enemy.global_position)
		if dist < best_dist:
			best_dist = dist
			best = enemy
	return best

func set_fire_rate(new_rate: float) -> void:
	fire_rate = new_rate
	if _fire_timer:
		_fire_timer.wait_time = 1.0 / fire_rate
