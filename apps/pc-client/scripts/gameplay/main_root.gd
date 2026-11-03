# Main Root Orchestrator
# Switches between Main Menu, Settings, and Arena Scenes
class_name MainRoot
extends Node

@onready var main_menu: MainMenu = $MainMenu
@onready var settings_menu: SettingsMenu = $SettingsMenu

func _ready() -> void:
	if settings_menu:
		settings_menu.visible = false
		settings_menu.back_pressed.connect(_on_settings_back)

	if main_menu:
		main_menu.play_practice_pressed.connect(_on_play_practice)
		main_menu.settings_pressed.connect(_on_settings_opened)
		main_menu.quit_pressed.connect(_on_quit)

func _on_play_practice() -> void:
	get_tree().change_scene_to_file("res://scenes/arena/arena.tscn")

func _on_settings_opened() -> void:
	if settings_menu:
		settings_menu.visible = true

func _on_settings_back() -> void:
	if settings_menu:
		settings_menu.visible = false

func _on_quit() -> void:
	get_tree().quit()

