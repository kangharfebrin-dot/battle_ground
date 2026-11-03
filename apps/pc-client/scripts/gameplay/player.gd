# Player Controller
# 2D Top-Down tactical operative with WASD movement, 360-degree mouse aiming, dash, dynamic camera shake
class_name Player
extends CharacterBody2D

signal died()
signal weapon_switched(weapon_id: String)

@onready var health: Health = $Health
@onready var weapon: Weapon = $Weapon
@onready var camera: Camera2D = $Camera2D
@onready var muzzle_marker: Marker2D = $MuzzleMarker

var move_speed: float = 300.0
var sprint_speed: float = 450.0
var dash_speed: float = 700.0
var dash_duration: float = 0.15
var dash_cooldown: float = 1.0
var body_radius: float = 16.0

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

var available_weapons: Array[String] = ["pistol", "shotgun", "rifle"]
var current_weapon_index: int = 0

# Screen Shake (Trauma model)
var trauma: float = 0.0
var trauma_decay: float = 1.8
var max_shake_offset: float = 12.0
var max_shake_roll: float = 0.05

var is_flashing: bool = false
var flash_timer: float = 0.0

func _ready() -> void:
	add_to_group("player")
	_load_character_stats()

	if health:
		health.died.connect(_on_died)
		health.damaged.connect(_on_damaged)

	if weapon:
		weapon.fired.connect(_on_weapon_fired)

	queue_redraw()

func _load_character_stats() -> void:
	var data_loader = get_node_or_null("/root/GameDataLoader")
	if data_loader and data_loader.has_method("get_character_data"):
		var c_data = data_loader.get_character_data()
		if c_data.has("baseStats"):
			var stats = c_data["baseStats"]
			move_speed = float(stats.get("moveSpeed", 300.0))
			sprint_speed = float(stats.get("sprintSpeed", 450.0))
			dash_speed = float(stats.get("dashSpeed", 700.0))
			dash_duration = float(stats.get("dashDuration", 0.15))
			dash_cooldown = float(stats.get("dashCooldown", 1.0))
			body_radius = float(stats.get("radius", 16.0))
			if health:
				health.init(int(stats.get("maxHealth", 100)))

func _unhandled_input(event: InputEvent) -> void:
	if not health or not health.is_alive():
		return

	if event.is_action_pressed("reload") and weapon:
		weapon.start_reload()
	elif event.is_action_pressed("dash") and not is_dashing and dash_cooldown_timer <= 0.0:
		_start_dash()
	elif event.is_action_pressed("weapon_1"):
		_switch_weapon(0)
	elif event.is_action_pressed("weapon_2"):
		_switch_weapon(1)
	elif event.is_action_pressed("weapon_3"):
		_switch_weapon(2)

func _process(delta: float) -> void:
	_process_screen_shake(delta)
	_update_damage_flash(delta)

func _physics_process(delta: float) -> void:
	if not health or not health.is_alive():
		return

	_handle_aiming()
	_handle_dash(delta)

	if not is_dashing:
		_handle_movement()

	move_and_slide()

	if Input.is_action_pressed("fire"):
		_handle_shooting()

func _handle_aiming() -> void:
	var mouse_pos = get_global_mouse_position()
	var aim_dir = (mouse_pos - global_position).normalized()
	if aim_dir.length_squared() > 0.001:
		rotation = aim_dir.angle()

func _handle_movement() -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed = sprint_speed if Input.is_action_pressed("sprint") else move_speed
	velocity = input_vector * speed

func _handle_dash(delta: float) -> void:
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer = maxf(0.0, dash_cooldown_timer - delta)

	if is_dashing:
		dash_timer -= delta
		velocity = dash_direction * dash_speed
		if dash_timer <= 0.0:
			is_dashing = false
			dash_cooldown_timer = dash_cooldown

func _start_dash() -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector.length_squared() < 0.01:
		input_vector = Vector2.from_angle(rotation)

	dash_direction = input_vector.normalized()
	is_dashing = true
	dash_timer = dash_duration
	add_trauma(0.1)

	var audio_mgr = get_node_or_null("/root/AudioManager")
	if audio_mgr and audio_mgr.has_method("play_sfx"):
		audio_mgr.play_sfx("dash", 1.2)

func _handle_shooting() -> void:
	if not weapon:
		return

	var muzzle_pos = muzzle_marker.global_position if muzzle_marker else global_position
	var aim_dir = Vector2.from_angle(rotation)
	var projectiles_container = get_parent()
	weapon.fire(self, muzzle_pos, aim_dir, projectiles_container)

func _switch_weapon(index: int) -> void:
	if index >= 0 and index < available_weapons.size() and weapon:
		current_weapon_index = index
		var w_id = available_weapons[index]
		weapon.load_weapon_stats(w_id)
		weapon_switched.emit(w_id)

func take_damage(amount: int, source: Node = null) -> void:
	if health and health.is_alive():
		health.take_damage(amount, source)

func _on_damaged(_amount: int, _source: Node) -> void:
	add_trauma(0.4)
	is_flashing = true
	flash_timer = 0.12
	queue_redraw()

func _on_weapon_fired() -> void:
	add_trauma(0.12)

func add_trauma(amount: float) -> void:
	trauma = clampf(trauma + amount, 0.0, 1.0)

func _process_screen_shake(delta: float) -> void:
	if not camera:
		return

	if trauma > 0.0:
		trauma = maxf(0.0, trauma - trauma_decay * delta)
		var shake = trauma * trauma
		camera.offset = Vector2(
			randf_range(-max_shake_offset, max_shake_offset) * shake,
			randf_range(-max_shake_offset, max_shake_offset) * shake
		)
		camera.rotation = randf_range(-max_shake_roll, max_shake_roll) * shake
	else:
		camera.offset = Vector2.ZERO
		camera.rotation = 0.0

func _update_damage_flash(delta: float) -> void:
	if is_flashing:
		flash_timer -= delta
		if flash_timer <= 0.0:
			is_flashing = false
			queue_redraw()

func _on_died() -> void:
	velocity = Vector2.ZERO
	add_trauma(0.8)
	died.emit()
	queue_redraw()

func _draw() -> void:
	if health and not health.is_alive():
		draw_circle(Vector2.ZERO, body_radius, Color(0.3, 0.3, 0.3, 0.6))
		return

	var body_color = Color(1.0, 0.4, 0.4) if is_flashing else Color(0.2, 0.45, 0.85)

	# Operative Body
	draw_circle(Vector2.ZERO, body_radius, body_color)
	draw_circle(Vector2.ZERO, body_radius - 3.0, body_color.darkened(0.25))

	# Visor / Helmet accent
	draw_circle(Vector2(6, 0), 4.0, Color(0.3, 0.8, 1.0))

	# Weapon barrel pointing right (0 rads)
	draw_rect(Rect2(12, -3, 14, 6), Color(0.2, 0.2, 0.2))
