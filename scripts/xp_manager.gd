extends Node
## Tracks XP, current level, and triggers level-up events.

signal level_up(level: int)

@export var base_threshold: int = 5
@export var threshold_growth: float = 1.4

var current_xp: int = 0
var current_level: int = 1
var xp_to_next: int

func _ready() -> void:
	xp_to_next = base_threshold

func add_xp(amount: int) -> void:
	current_xp += amount
	while current_xp >= xp_to_next:
		current_xp -= xp_to_next
		current_level += 1
		xp_to_next = int(base_threshold * pow(threshold_growth, current_level - 1))
		level_up.emit(current_level)

func get_xp_ratio() -> float:
	if xp_to_next <= 0:
		return 0.0
	return float(current_xp) / float(xp_to_next)

func reset() -> void:
	current_xp = 0
	current_level = 1
	xp_to_next = base_threshold
