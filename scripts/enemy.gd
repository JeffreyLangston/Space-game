extends CharacterBody2D
## Enemy — steers toward player, deals contact damage, drops XP gem on death.

signal died(enemy: CharacterBody2D)

@export var max_hp: float = 15.0
@export var move_speed: float = 80.0
@export var contact_damage: float = 10.0
@export var xp_value: int = 1
@export var coin_drop_chance: float = 0.15

var hp: float
var _player: CharacterBody2D

func _ready() -> void:
	hp = max_hp

func init(player: CharacterBody2D) -> void:
	_player = player

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(_player):
		return
	var dir := global_position.direction_to(_player.global_position)
	velocity = dir * move_speed
	move_and_slide()

func take_hit(damage: float) -> void:
	hp -= damage
	if hp <= 0.0:
		died.emit(self)
		queue_free()

func _draw() -> void:
	# Placeholder: red circle
	draw_circle(Vector2.ZERO, 12.0, Color(0.9, 0.2, 0.2))
