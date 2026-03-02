extends CanvasLayer
## Debug overlay — shows FPS, enemy count, wave, player pos. Toggle via triple-tap.

@onready var _label: Label = $DebugLabel

var _tap_times: Array[float] = []
const TAP_WINDOW := 0.5  # seconds

var _spawner: Node
var _player: CharacterBody2D

func init(player: CharacterBody2D, spawner: Node) -> void:
	_player = player
	_spawner = spawner

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		var now := Time.get_ticks_msec() / 1000.0
		_tap_times.append(now)
		# Keep only taps within the window
		while _tap_times.size() > 0 and now - _tap_times[0] > TAP_WINDOW:
			_tap_times.pop_front()
		if _tap_times.size() >= 3:
			visible = not visible
			_tap_times.clear()

func _process(_delta: float) -> void:
	if not visible:
		return
	var fps := Engine.get_frames_per_second()
	var enemies := 0
	var wave := 0
	var pos := Vector2.ZERO
	if _spawner:
		enemies = _spawner.get_enemy_count()
		wave = _spawner.get_wave()
	if is_instance_valid(_player):
		pos = _player.global_position
	_label.text = "FPS: %d\nEnemies: %d\nWave: %d\nPos: (%d, %d)" % [
		fps, enemies, wave, int(pos.x), int(pos.y)
	]
