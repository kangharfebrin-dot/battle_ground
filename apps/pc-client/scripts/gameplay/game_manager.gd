# Game Manager (Arena Match Coordinator)
# Oversees match timer, target dummies, score tracking, player lifecycle, and HUD updates
class_name GameManager
extends Node2D

signal match_ended(final_score: int)

@export var match_duration: float = 300.0 # 5 minutes

@onready var arena_bounds: ArenaBounds = $ArenaBounds
@onready var player: Player = $Player
@onready var hud: HUD = $HUD
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var targets_container: Node2D = $TargetsContainer

var score: int = 0
var time_remaining: float = 300.0
var is_active: bool = true

var dummy_scene: PackedScene = preload("res://scenes/arena/target_dummy.tscn")

func _ready() -> void:
	time_remaining = match_duration

	if hud and player:
		hud.setup(player)
		hud.update_score(score)
		hud.update_timer(time_remaining)

	if player:
		player.died.connect(_on_player_died)

	if pause_menu:
		pause_menu.restart_requested.connect(_on_restart_match)
		pause_menu.exit_to_menu_requested.connect(_on_exit_to_menu)

	_spawn_target_dummies()

func _process(delta: float) -> void:
	if not is_active:
		return

	time_remaining -= delta
	if hud:
		hud.update_timer(maxf(0.0, time_remaining))

	if time_remaining <= 0.0:
		_end_match()

func _spawn_target_dummies() -> void:
	var dummy_positions = [
		Vector2(500, 450),
		Vector2(1100, 450),
		Vector2(500, 750),
		Vector2(1100, 750),
		Vector2(800, 350),
		Vector2(800, 850)
	]

	for pos in dummy_positions:
		var dummy = dummy_scene.instantiate() as TargetDummy
		dummy.position = pos
		dummy.dummy_destroyed.connect(_on_dummy_destroyed)
		targets_container.add_child(dummy)

func _on_dummy_destroyed(_dummy: Node2D) -> void:
	score += 100
	if hud:
		hud.update_score(score)

func _on_player_died() -> void:
	# In practice mode, respawn player after 2 seconds
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(player):
		player.global_position = Vector2(800, 600)
		if player.health:
			player.health.reset()

func _end_match() -> void:
	is_active = false
	match_ended.emit(score)

func _on_restart_match() -> void:
	get_tree().reload_current_scene()

func _on_exit_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

