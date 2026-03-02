extends Node
## Autoload singleton — persists stats, coins, unlocks, and loadout.

const SAVE_PATH := "user://save.cfg"

var best_time: float = 0.0
var best_level: int = 0
var runs_played: int = 0
var coins: int = 0
var unlocked_weapons: Array[String] = ["blaster"]
var unlocked_armor: Array[String] = ["none"]
var unlocked_ships: Array[String] = ["default"]
var equipped_weapon: String = "blaster"
var equipped_armor: String = "none"
var equipped_ship: String = "default"
var discoveries: Array[String] = []

func _ready() -> void:
	load_data()

func save_data() -> void:
	var config := ConfigFile.new()
	config.set_value("stats", "best_time", best_time)
	config.set_value("stats", "best_level", best_level)
	config.set_value("stats", "runs_played", runs_played)
	config.set_value("stats", "coins", coins)
	config.set_value("unlocks", "weapons", unlocked_weapons)
	config.set_value("unlocks", "armor", unlocked_armor)
	config.set_value("unlocks", "ships", unlocked_ships)
	config.set_value("loadout", "weapon", equipped_weapon)
	config.set_value("loadout", "armor", equipped_armor)
	config.set_value("loadout", "ship", equipped_ship)
	config.set_value("unlocks", "discoveries", discoveries)
	config.save(SAVE_PATH)

func load_data() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	best_time = config.get_value("stats", "best_time", 0.0)
	best_level = config.get_value("stats", "best_level", 0)
	runs_played = config.get_value("stats", "runs_played", 0)
	coins = config.get_value("stats", "coins", 0)
	unlocked_weapons = config.get_value("unlocks", "weapons", ["blaster"])
	unlocked_armor = config.get_value("unlocks", "armor", ["none"])
	unlocked_ships = config.get_value("unlocks", "ships", ["default"])
	equipped_weapon = config.get_value("loadout", "weapon", "blaster")
	equipped_armor = config.get_value("loadout", "armor", "none")
	equipped_ship = config.get_value("loadout", "ship", "default")
	discoveries = config.get_value("unlocks", "discoveries", [])

func end_run(time: float, level: int, run_coins: int) -> void:
	runs_played += 1
	if time > best_time:
		best_time = time
	if level > best_level:
		best_level = level
	coins += run_coins
	save_data()
