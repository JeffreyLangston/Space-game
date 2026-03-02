extends Node2D
## Run — core gameplay scene. Wires all systems together.

@onready var _player: CharacterBody2D = $Player
@onready var _spawner: Node = $Spawner
@onready var _xp_manager: Node = $XPManager
@onready var _hud: CanvasLayer = $HUD
@onready var _debug_overlay: CanvasLayer = $DebugOverlay

var _game_over := false

func _ready() -> void:
	_hud.init(_player, _xp_manager, _spawner)
	_debug_overlay.init(_player, _spawner)
	_player.died.connect(_on_player_died)
	_spawner.boss_spawned.connect(_on_boss_spawned)
	# XP gem magnet: when gems enter pickup area, start magnet
	var pickup_area: Area2D = _player.get_node("PickupArea")
	pickup_area.area_entered.connect(_on_pickup_area_entered)

func _on_player_died() -> void:
	if _game_over:
		return
	_game_over = true
	var main: Node = get_parent()
	if main.has_method("show_game_over"):
		main.show_game_over(false, _spawner.get_elapsed(), _xp_manager.current_level, _player.run_coins)

func _on_boss_spawned() -> void:
	# M2 will add actual boss — for now just log it
	print("Boss should spawn at 99s — boss entity added in M2")

func _on_pickup_area_entered(area: Area2D) -> void:
	if area.has_method("start_magnet"):
		area.start_magnet()

# Contact damage: enemies touching the player
func _physics_process(_delta: float) -> void:
	if _game_over:
		return
	# Check for enemy contact damage
	for i in _player.get_slide_collision_count():
		var collision := _player.get_slide_collision(i)
		var collider := collision.get_collider()
		if collider is CharacterBody2D and collider.has_method("take_hit"):
			# Enemy is touching player — deal contact damage per frame
			_player.take_damage(collider.contact_damage * get_physics_process_delta_time())
