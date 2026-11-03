# SettingsManager (Autoload Singleton)
# Manages user preferences: Display, Audio, Controls, and config persistence
extends Node

signal settings_changed
signal mouse_sensitivity_changed(new_sensitivity: float)

const SETTINGS_PATH = "user://settings.cfg"

var master_volume: float = 0.8
var music_volume: float = 0.7
var sfx_volume: float = 0.85
var mouse_sensitivity: float = 1.0
var fullscreen: bool = false
var vsync: bool = true

func _ready() -> void:
	load_settings()
	apply_settings()

func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	if err == OK:
		master_volume = config.get_value("audio", "master_volume", 0.8)
		music_volume = config.get_value("audio", "music_volume", 0.7)
		sfx_volume = config.get_value("audio", "sfx_volume", 0.85)
		mouse_sensitivity = config.get_value("controls", "mouse_sensitivity", 1.0)
		fullscreen = config.get_value("display", "fullscreen", false)
		vsync = config.get_value("display", "vsync", true)

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("controls", "mouse_sensitivity", mouse_sensitivity)
	config.set_value("display", "fullscreen", fullscreen)
	config.set_value("display", "vsync", vsync)
	config.save(SETTINGS_PATH)

func apply_settings() -> void:
	# Display
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED
	)

	# Audio
	var master_bus = AudioServer.get_bus_index("Master")
	if master_bus >= 0:
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_volume))
		AudioServer.set_bus_mute(master_bus, master_volume <= 0.001)

	settings_changed.emit()

func set_mouse_sensitivity(value: float) -> void:
	mouse_sensitivity = clampf(value, 0.1, 5.0)
	mouse_sensitivity_changed.emit(mouse_sensitivity)
	save_settings()

func set_fullscreen_mode(is_fs: bool) -> void:
	fullscreen = is_fs
	apply_settings()
	save_settings()

func set_volumes(master: float, music: float, sfx: float) -> void:
	master_volume = clampf(master, 0.0, 1.0)
	music_volume = clampf(music, 0.0, 1.0)
	sfx_volume = clampf(sfx, 0.0, 1.0)
	apply_settings()
	save_settings()

