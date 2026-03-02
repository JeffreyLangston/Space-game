extends Area2D
## XP gem — sits on ground, lerps toward player when in pickup radius, adds XP.

@export var xp_value: int = 1
@export var magnet_speed: float = 300.0

var _being_collected := false
var _player: CharacterBody2D

func init(player: CharacterBody2D, value: int) -> void:
	_player = player
	xp_value = value

func _physics_process(delta: float) -> void:
	if not _being_collected or not is_instance_valid(_player):
		return
	var dir := global_position.direction_to(_player.global_position)
	position += dir * magnet_speed * delta
	if global_position.distance_to(_player.global_position) < 10.0:
		_collect()

func start_magnet() -> void:
	_being_collected = true

func _collect() -> void:
	var xp_mgr := get_node_or_null("/root/Main/Run/XPManager")
	if xp_mgr and xp_mgr.has_method("add_xp"):
		xp_mgr.add_xp(xp_value)
	queue_free()

func _draw() -> void:
	# Placeholder: green diamond
	var points := PackedVector2Array([
		Vector2(0, -6), Vector2(6, 0), Vector2(0, 6), Vector2(-6, 0)
	])
	draw_colored_polygon(points, Color(0.2, 0.9, 0.3))
