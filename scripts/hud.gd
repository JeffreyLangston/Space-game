extends CanvasLayer
## HUD — displays HP, XP, level, timer, coins. Pure display, no game logic.

@onready var _hp_bar: ProgressBar = $MarginContainer/TopBar/HPBar
@onready var _xp_bar: ProgressBar = $MarginContainer/TopBar/XPBar
@onready var _level_label: Label = $MarginContainer/TopBar/LevelLabel
@onready var _timer_label: Label = $MarginContainer/TopBar/TimerLabel
@onready var _coin_label: Label = $MarginContainer/TopBar/CoinLabel

var _player: CharacterBody2D
var _xp_manager: Node
var _spawner: Node

func init(player: CharacterBody2D, xp_manager: Node, spawner: Node) -> void:
	_player = player
	_xp_manager = xp_manager
	_spawner = spawner

func _process(_delta: float) -> void:
	if not is_instance_valid(_player):
		return
	# HP
	_hp_bar.value = (_player.hp / _player.max_hp) * 100.0
	# XP
	_xp_bar.value = _xp_manager.get_xp_ratio() * 100.0
	# Level
	_level_label.text = "Lv %d" % _xp_manager.current_level
	# Timer
	var elapsed: float = _spawner.get_elapsed()
	var secs := int(elapsed)
	_timer_label.text = "%d:%02d" % [secs / 60, secs % 60]
	# Coins
	_coin_label.text = "%d" % _player.run_coins
