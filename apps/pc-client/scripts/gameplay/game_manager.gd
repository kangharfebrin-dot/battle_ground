# Game Manager (Arena Match Coordinator)
# Oversees match timer, target dummies, AI enemy bots, score tracking, kill feed, and Victory/Defeat
class_name GameManager
extends Node2D

signal match_ended(final_score: int)

@export var match_duration: float = 300.0 # 5 minutes
@export var kill_target: int = 10

@onready var arena_bounds: ArenaBounds = $ArenaBounds
@onready var player: Player = $Player
@onready var hud: HUD = $HUD
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var victory_screen: VictoryScreen = $VictoryScreen
@onready var targets_container: Node2D = $TargetsContainer

var score: int = 0
var total_kills: int = 0
var time_remaining: float = 300.0
var is_active: bool = true

var dummy_scene: PackedScene = preload("res://scenes/arena/target_dummy.tscn")
var bot_scene: PackedScene = preload("res://scenes/enemies/enemy_bot.tscn")

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

	if victory_screen:
		victory_screen.play_again_requested.connect(_on_restart_match)
		victory_screen.main_menu_requested.connect(_on_exit_to_menu)

	_spawn_target_dummies()
	_spawn_enemy_bots()

func _process(delta: float) -> void:
	if not is_active:
		return

	time_remaining -= delta
	if hud:
		hud.update_timer(maxf(0.0, time_remaining))

	if time_remaining <= 0.0:
		_end_match(total_kills >= kill_target)

func _spawn_target_dummies() -> void:
	var dummy_positions = [
		Vector2(400, 450),
		Vector2(1200, 450),
		Vector2(400, 750),
		Vector2(1200, 750)
	]

	for pos in dummy_positions:
		var dummy = dummy_scene.instantiate() as TargetDummy
		dummy.position = pos
		dummy.dummy_destroyed.connect(_on_dummy_destroyed)
		targets_container.add_child(dummy)

func _spawn_enemy_bots() -> void:
	var bot_positions = [
		Vector2(800, 250),
		Vector2(800, 950),
		Vector2(300, 600),
		Vector2(1300, 600)
	]

	for pos in bot_positions:
		var bot = bot_scene.instantiate() as EnemyBot
		bot.position = pos
		bot.bot_killed.connect(_on_bot_killed)
		targets_container.add_child(bot)

func _on_dummy_destroyed(_dummy: Node2D) -> void:
	score += 100
	total_kills += 1
	if hud:
		hud.update_score(score)
		hud.add_kill_feed("Player", "Target Dummy")

	if total_kills >= kill_target:
		_end_match(true)

func _on_bot_killed(_bot: Node2D, _killer: Node) -> void:
	score += 150
	total_kills += 1
	if hud:
		hud.update_score(score)
		hud.add_kill_feed("Player", "Hostile Bot")

	if total_kills >= kill_target:
		_end_match(true)

func _on_player_died() -> void:
	if hud:
		hud.add_kill_feed("Hostile Bot", "Player")

	# In practice mode, respawn player after 2 seconds
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(player):
		player.global_position = Vector2(800, 600)
		if player.health:
			player.health.reset()

func _end_match(is_victory: bool) -> void:
	is_active = false
	match_ended.emit(score)
	if victory_screen:
		victory_screen.show_summary(is_victory, score, total_kills)

func _on_restart_match() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
