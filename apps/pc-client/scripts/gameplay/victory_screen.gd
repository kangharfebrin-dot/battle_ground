# Victory / Match Summary Screen
# Displays match end telemetry: Final Score, Kills, Victory/Defeat status, and replay options
class_name VictoryScreen
extends CanvasLayer

signal play_again_requested()
signal main_menu_requested()

@onready var title_label: Label = $Panel/VBox/Title
@onready var score_label: Label = $Panel/VBox/ScoreLabel
@onready var kills_label: Label = $Panel/VBox/KillsLabel
@onready var replay_btn: Button = $Panel/VBox/PlayAgainBtn
@onready var menu_btn: Button = $Panel/VBox/MainMenuBtn

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	if replay_btn:
		replay_btn.pressed.connect(_on_play_again)
	if menu_btn:
		menu_btn.pressed.connect(_on_main_menu)

func show_summary(is_victory: bool, final_score: int, total_kills: int) -> void:
	visible = true
	get_tree().paused = true

	if title_label:
		title_label.text = "VICTORY ACHIEVED" if is_victory else "MATCH FINISHED"
		title_label.modulate = Color(0.3, 0.9, 0.4) if is_victory else Color(0.9, 0.6, 0.2)

	if score_label:
		score_label.text = "FINAL SCORE: %d" % final_score

	if kills_label:
		kills_label.text = "TOTAL ELIMINATIONS: %d" % total_kills

func _on_play_again() -> void:
	get_tree().paused = false
	visible = false
	play_again_requested.emit()

func _on_main_menu() -> void:
	get_tree().paused = false
	visible = false
	main_menu_requested.emit()

