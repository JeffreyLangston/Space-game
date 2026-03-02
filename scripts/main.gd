extends Node
## Main — scene manager. Loads Run scene directly for M1 (title screen added in M3).

var _current_scene: Node = null

func _ready() -> void:
	start_run()

func start_run() -> void:
	_clear_current()
	var run_scene: PackedScene = load("res://scenes/Run.tscn")
	_current_scene = run_scene.instantiate()
	add_child(_current_scene)

func show_game_over(won: bool, time: float, level: int, coins: int) -> void:
	# M2 will add GameOver scene — for now just restart
	SaveManager.end_run(time, level, coins)
	start_run()

func _clear_current() -> void:
	if _current_scene and is_instance_valid(_current_scene):
		_current_scene.queue_free()
		_current_scene = null
