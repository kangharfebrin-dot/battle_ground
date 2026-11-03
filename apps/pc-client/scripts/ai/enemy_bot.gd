# Enemy Bot AI Controller
# Autonomous combatant using Finite State Machine: IDLE, PATROL, CHASE, ATTACK, DEAD
class_name EnemyBot
extends CharacterBody2D

signal bot_killed(bot: Node2D, killer: Node)

enum State {
	IDLE,
	PATROL,
	CHASE,
	ATTACK,
	DEAD
}

@export var move_speed: float = 180.0
@export var chase_speed: float = 240.0
@export var detection_radius: float = 350.0
@export var attack_radius: float = 220.0
@export var fire_cooldown_time: float = 0.8
@export var body_radius: float = 16.0

@onready var health: Health = $Health

var current_state: State = State.IDLE
var target_player: Node2D = null

var _state_timer: float = 0.0
var _fire_timer: float = 0.0
var _patrol_destination: Vector2 = Vector2.ZERO
var _spawn_position: Vector2 = Vector2.ZERO
var _respawn_timer: float = 0.0

var is_flashing: bool = false
var flash_timer: float = 0.0
var base_color: Color = Color(0.85, 0.2, 0.2)
var flash_color: Color = Color(1.0, 0.7, 0.7)

var projectile_scene: PackedScene = preload("res://scenes/combat/projectile.tscn")

func _ready() -> void:
	_spawn_position = global_position
	if health:
		health.init(80)
		health.damaged.connect(_on_damaged)
		health.died.connect(_on_died)

	_set_state(State.IDLE)
	queue_redraw()

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		_process_dead(delta)
		return

	_update_damage_flash(delta)
	_acquire_target()

	match current_state:
		State.IDLE:
			_process_idle(delta)
		State.PATROL:
			_process_patrol(delta)
		State.CHASE:
			_process_chase(delta)
		State.ATTACK:
			_process_attack(delta)

	move_and_slide()

func _acquire_target() -> void:
	if not is_instance_valid(target_player):
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			target_player = players[0] as Node2D

func _set_state(new_state: State) -> void:
	current_state = new_state
	match current_state:
		State.IDLE:
			_state_timer = randf_range(1.0, 2.0)
			velocity = Vector2.ZERO
		State.PATROL:
			_state_timer = randf_range(3.0, 5.0)
			_patrol_destination = _spawn_position + Vector2(randf_range(-150, 150), randf_range(-150, 150))
		State.CHASE:
			pass
		State.ATTACK:
			velocity = Vector2.ZERO
			_fire_timer = 0.2
		State.DEAD:
			velocity = Vector2.ZERO
			_respawn_timer = 4.0
			set_collision_layer_value(2, false)
			queue_redraw()

func _process_idle(delta: float) -> void:
	_state_timer -= delta
	if _can_see_target():
		_set_state(State.CHASE)
		return

	if _state_timer <= 0.0:
		_set_state(State.PATROL)

func _process_patrol(delta: float) -> void:
	_state_timer -= delta
	if _can_see_target():
		_set_state(State.CHASE)
		return

	var diff = _patrol_destination - global_position
	if diff.length() < 16.0 or _state_timer <= 0.0:
		_set_state(State.IDLE)
		return

	var dir = diff.normalized()
	velocity = dir * move_speed
	rotation = dir.angle()

func _process_chase(_delta: float) -> void:
	if not is_instance_valid(target_player):
		_set_state(State.IDLE)
		return

	var diff = target_player.global_position - global_position
	var dist = diff.length()

	if dist > detection_radius * 1.3:
		_set_state(State.PATROL)
		return

	if dist <= attack_radius:
		_set_state(State.ATTACK)
		return

	var dir = diff.normalized()
	velocity = dir * chase_speed
	rotation = dir.angle()

func _process_attack(delta: float) -> void:
	if not is_instance_valid(target_player):
		_set_state(State.IDLE)
		return

	var diff = target_player.global_position - global_position
	var dist = diff.length()

	if dist > attack_radius * 1.2:
		_set_state(State.CHASE)
		return

	# Face player directly
	var aim_dir = diff.normalized()
	rotation = aim_dir.angle()
	velocity = Vector2.ZERO

	# Fire cooldown
	_fire_timer -= delta
	if _fire_timer <= 0.0:
		_fire_projectile(aim_dir)
		_fire_timer = fire_cooldown_time

func _fire_projectile(dir: Vector2) -> void:
	var muzzle_offset = dir * 24.0
	var muzzle_pos = global_position + muzzle_offset
	var bullet = projectile_scene.instantiate() as Projectile
	var container = get_parent()
	if container:
		container.add_child(bullet)
		bullet.setup(self, muzzle_pos, dir, 700.0, 15, 500.0)

	var audio_mgr = get_node_or_null("/root/AudioManager")
	if audio_mgr and audio_mgr.has_method("play_sfx"):
		audio_mgr.play_sfx("shoot", 0.85)

func _can_see_target() -> bool:
	if not is_instance_valid(target_player):
		return false
	var dist = global_position.distance_to(target_player.global_position)
	return dist <= detection_radius

func take_damage(amount: int, source: Node = null) -> void:
	var h = health if health else get_node_or_null("Health") as Health
	if current_state != State.DEAD and h:
		h.take_damage(amount, source)

func _on_damaged(_amount: int, source: Node) -> void:
	is_flashing = true
	flash_timer = 0.1
	queue_redraw()

	# Retaliate / turn towards attacker
	if source and source != self and current_state != State.DEAD:
		target_player = source as Node2D
		_set_state(State.CHASE)

func _on_died() -> void:
	_set_state(State.DEAD)
	bot_killed.emit(self, target_player)

func _process_dead(delta: float) -> void:
	_respawn_timer -= delta
	if _respawn_timer <= 0.0:
		_respawn()

func _respawn() -> void:
	global_position = _spawn_position
	if health:
		health.reset()
	set_collision_layer_value(2, true)
	_set_state(State.IDLE)
	queue_redraw()

func _update_damage_flash(delta: float) -> void:
	if is_flashing:
		flash_timer -= delta
		if flash_timer <= 0.0:
			is_flashing = false
			queue_redraw()

func _draw() -> void:
	if current_state == State.DEAD:
		draw_circle(Vector2.ZERO, body_radius, Color(0.3, 0.1, 0.1, 0.4))
		return

	var col = flash_color if is_flashing else base_color

	# Hostile Operative Body
	draw_circle(Vector2.ZERO, body_radius, col)
	draw_circle(Vector2.ZERO, body_radius - 3.0, col.darkened(0.3))

	# Red Optical Sensor / Visor
	draw_circle(Vector2(6, 0), 4.0, Color(1.0, 0.9, 0.2))

	# Heavy barrel pointer
	draw_rect(Rect2(12, -3, 12, 6), Color(0.15, 0.15, 0.15))
