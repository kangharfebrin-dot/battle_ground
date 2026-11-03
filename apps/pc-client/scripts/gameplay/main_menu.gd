# Main Menu Controller
# Handles navigation to Practice Arena, Settings dialog, and Exit
class_name MainMenu
extends Control

signal play_practice_pressed()
signal settings_pressed()
signal quit_pressed()

@onready var play_btn: Button = $VBoxContainer/PlayBtn
@onready var settings_btn: Button = $VBoxContainer/SettingsBtn
@onready var quit_btn: Button = $VBoxContainer/QuitBtn

func _ready() -> void:
	if play_btn:
		play_btn.pressed.connect(func(): play_practice_pressed.emit())
	if settings_btn:
		settings_btn.pressed.connect(func(): settings_pressed.emit())
	if quit_btn:
		quit_btn.pressed.connect(func(): quit_pressed.emit())

