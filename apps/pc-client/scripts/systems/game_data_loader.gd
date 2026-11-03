# GameDataLoader (Autoload Singleton)
# Loads shared game configuration data from res://resources/data/
extends Node

var character_data: Dictionary = {}
var weapons_data: Dictionary = {}
var arena_data: Dictionary = {}

func _ready() -> void:
	load_all_data()

func load_all_data() -> void:
	character_data = _load_json("res://resources/data/character.json", _get_default_character())
	weapons_data = _load_json("res://resources/data/weapons.json", _get_default_weapons())
	arena_data = _load_json("res://resources/data/arena.json", _get_default_arena())

func _load_json(path: String, fallback: Dictionary) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_warning("Game data file not found: " + path + ". Using fallback data.")
		return fallback

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Failed to open file: " + path)
		return fallback

	var text = file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(text)
	if parse_result != OK:
		push_error("JSON Parse Error in " + path + ": " + json.get_error_message())
		return fallback

	if json.data is Dictionary:
		return json.data
	return fallback

func get_character_data() -> Dictionary:
	return character_data

func get_weapons_data() -> Dictionary:
	return weapons_data

func get_arena_data() -> Dictionary:
	return arena_data

func get_weapon(weapon_id: String) -> Dictionary:
	if weapons_data.has("weapons") and weapons_data["weapons"].has(weapon_id):
		return weapons_data["weapons"][weapon_id]
	if weapons_data.has(weapon_id):
		return weapons_data[weapon_id]
	return {
		"id": "pistol",
		"name": "Standard Pistol",
		"fireRate": 3.0,
		"damage": 20,
		"magazineSize": 12,
		"reloadTime": 1.2,
		"bulletSpeed": 800,
		"bulletRange": 600,
		"spread": 2.0
	}

# Fallbacks matching packages/game-data
func _get_default_character() -> Dictionary:
	return {
		"baseStats": {
			"maxHealth": 100,
			"moveSpeed": 300,
			"sprintSpeed": 450,
			"dashSpeed": 700,
			"dashDuration": 0.15,
			"dashCooldown": 1.0,
			"radius": 16
		}
	}

func _get_default_weapons() -> Dictionary:
	return {
		"weapons": {
			"pistol": {
				"id": "pistol",
				"name": "Standard Pistol",
				"fireRate": 3.0,
				"damage": 20,
				"magazineSize": 12,
				"reloadTime": 1.2,
				"bulletSpeed": 800,
				"bulletRange": 600,
				"spread": 2.0
			},
			"shotgun": {
				"id": "shotgun",
				"name": "Pump Shotgun",
				"fireRate": 1.2,
				"damage": 12,
				"pellets": 6,
				"magazineSize": 6,
				"reloadTime": 2.0,
				"bulletSpeed": 700,
				"bulletRange": 400,
				"spread": 12.0
			},
			"rifle": {
				"id": "rifle",
				"name": "Assault Rifle",
				"fireRate": 8.0,
				"damage": 15,
				"magazineSize": 30,
				"reloadTime": 1.8,
				"bulletSpeed": 950,
				"bulletRange": 800,
				"spread": 4.5
			}
		}
	}

func _get_default_arena() -> Dictionary:
	return {
		"arenaId": "arena_alpha",
		"bounds": {
			"width": 1600,
			"height": 1200
		},
		"obstacles": [
			{"x": 400, "y": 300, "width": 80, "height": 80},
			{"x": 1200, "y": 300, "width": 80, "height": 80},
			{"x": 400, "y": 900, "width": 80, "height": 80},
			{"x": 1200, "y": 900, "width": 80, "height": 80},
			{"x": 800, "y": 600, "width": 120, "height": 120}
		]
	}

