extends Area2D
## Projectile — moves in a straight line, damages enemies on hit, despawns after TTL.

@export var speed: float = 400.0
@export var ttl: float = 2.0

var _direction: Vector2 = Vector2.RIGHT
var _damage: float = 10.0
var _time_alive: float = 0.0

func setup(dir: Vector2, damage: float) -> void:
	_direction = dir.normalized()
	_damage = damage
	rotation = _direction.angle()

func _physics_process(delta: float) -> void:
	position += _direction * speed * delta
	_time_alive += delta
	if _time_alive >= ttl:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		body.take_hit(_damage)
	queue_free()

func _draw() -> void:
	# Placeholder: white small circle
	draw_circle(Vector2.ZERO, 4.0, Color.WHITE)
