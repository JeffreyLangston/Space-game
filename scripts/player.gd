extends CharacterBody2D
## Player — moves via joystick, takes damage, collects pickups, dies.

signal died

@export var max_hp: float = 100.0
@export var move_speed: float = 200.0
@export var pickup_radius: float = 80.0
@export var hp_regen: float = 0.5

var hp: float
var run_coins: int = 0

@onready var _joystick: CanvasLayer = $"../VirtualJoystick"
@onready var _pickup_area: Area2D = $PickupArea

func _ready() -> void:
	hp = max_hp
	_update_pickup_radius()

func _physics_process(delta: float) -> void:
	# Movement
	var dir: Vector2 = _joystick.direction
	velocity = dir * move_speed
	move_and_slide()
	# Clamp to viewport
	var vp_rect := get_viewport_rect()
	global_position = global_position.clamp(vp_rect.position, vp_rect.end)
	# HP regen
	hp = minf(hp + hp_regen * delta, max_hp)

func take_damage(amount: float) -> void:
	hp -= amount
	if hp <= 0.0:
		hp = 0.0
		died.emit()

func _update_pickup_radius() -> void:
	var shape: CircleShape2D = _pickup_area.get_node("CollisionShape2D").shape
	shape.radius = pickup_radius

func _draw() -> void:
	# Placeholder: blue circle
	draw_circle(Vector2.ZERO, 16.0, Color(0.2, 0.4, 1.0))
