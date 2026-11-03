# Settings Menu Controller
# UI for configuring Display, Audio, and Input sensitivity
class_name SettingsMenu
extends Control

signal back_pressed()

@onready var fullscreen_check: CheckBox = $Panel/VBox/FullscreenCheck
@onready var master_slider: HSlider = $Panel/VBox/MasterSlider
@onready var sfx_slider: HSlider = $Panel/VBox/SFXSlider
@onready var sens_slider: HSlider = $Panel/VBox/SensSlider
@onready var sens_label: Label = $Panel/VBox/SensLabel
@onready var back_btn: Button = $Panel/VBox/BackBtn

func _ready() -> void:
	var settings_mgr = get_node_or_null("/root/SettingsManager")
	if settings_mgr:
		fullscreen_check.button_pressed = settings_mgr.fullscreen
		master_slider.value = settings_mgr.master_volume * 100.0
		sfx_slider.value = settings_mgr.sfx_volume * 100.0
		sens_slider.value = settings_mgr.mouse_sensitivity
		_update_sens_label(settings_mgr.mouse_sensitivity)

	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	master_slider.value_changed.connect(_on_master_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	sens_slider.value_changed.connect(_on_sens_changed)
	back_btn.pressed.connect(_on_back_pressed)

func _update_sens_label(val: float) -> void:
	if sens_label:
		sens_label.text = "Mouse Sensitivity: %.1fx" % val

func _on_fullscreen_toggled(is_fs: bool) -> void:
	var settings_mgr = get_node_or_null("/root/SettingsManager")
	if settings_mgr and settings_mgr.has_method("set_fullscreen_mode"):
		settings_mgr.set_fullscreen_mode(is_fs)

func _on_master_changed(val: float) -> void:
	var settings_mgr = get_node_or_null("/root/SettingsManager")
	if settings_mgr and settings_mgr.has_method("set_volumes"):
		settings_mgr.set_volumes(val / 100.0, settings_mgr.music_volume, settings_mgr.sfx_volume)

func _on_sfx_changed(val: float) -> void:
	var settings_mgr = get_node_or_null("/root/SettingsManager")
	if settings_mgr and settings_mgr.has_method("set_volumes"):
		settings_mgr.set_volumes(settings_mgr.master_volume, settings_mgr.music_volume, val / 100.0)

func _on_sens_changed(val: float) -> void:
	_update_sens_label(val)
	var settings_mgr = get_node_or_null("/root/SettingsManager")
	if settings_mgr and settings_mgr.has_method("set_mouse_sensitivity"):
		settings_mgr.set_mouse_sensitivity(val)

func _on_back_pressed() -> void:
	back_pressed.emit()
