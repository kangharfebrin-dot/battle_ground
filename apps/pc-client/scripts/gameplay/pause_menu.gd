# Pause Menu Controller
# Pauses game tree, handles resume, restart, and return to main menu
class_name PauseMenu
extends CanvasLayer

signal resume_requested()
signal restart_requested()
signal exit_to_menu_requested()

@onready var resume_btn: Button = $Panel/VBox/ResumeBtn
@onready var restart_btn: Button = $Panel/VBox/RestartBtn
@onready var exit_btn: Button = $Panel/VBox/ExitBtn

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	if resume_btn:
		resume_btn.pressed.connect(_on_resume_pressed)
	if restart_btn:
		restart_btn.pressed.connect(_on_restart_pressed)
	if exit_btn:
		exit_btn.pressed.connect(_on_exit_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			close_pause_menu()
		else:
			open_pause_menu()
		get_viewport().set_input_as_handled()

func open_pause_menu() -> void:
	visible = true
	get_tree().paused = true

func close_pause_menu() -> void:
	visible = false
	get_tree().paused = false
	resume_requested.emit()

func _on_resume_pressed() -> void:
	close_pause_menu()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	restart_requested.emit()

func _on_exit_pressed() -> void:
	get_tree().paused = false
	exit_to_menu_requested.emit()

