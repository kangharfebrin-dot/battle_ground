# PUBG-Inspired 3D Third-Person Shooter Character Controller
# Handles camera-relative movement, mouse orbit/pitch, sprint, jump, crouch, ADS, and skeletal animations
class_name PlayerController3D
extends CharacterBody3D

signal health_changed(current: int, max_hp: int)
signal died()

# Movement Parameters
@export var walk_speed: float = 4.5
@export var sprint_speed: float = 8.0
@export var crouch_speed: float = 2.5
@export var jump_velocity: float = 4.8
@export var acceleration: float = 12.0
@export var rotation_speed: float = 10.0

# Camera Parameters
@export var mouse_sensitivity: float = 0.0025
@export var min_pitch: float = -70.0 # Degrees
@export var max_pitch: float = 60.0  # Degrees

# ADS (Aim Down Sights) Parameters
@export var default_fov: float = 75.0
@export var ads_fov: float = 55.0
@export var default_arm_length: float = 3.0
@export var ads_arm_length: float = 1.4

# Health
@export var max_health: int = 100
var current_health: int = 100
var is_alive: bool = true

# State flags
var is_sprinting: bool = false
var is_crouching: bool = false
var is_aiming: bool = false

# Internal references
@onready var camera_pivot: Node3D = $CameraPivot
@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D
@onready var camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D
@onready var model_root: Node3D = $ModelRoot

var animation_player: AnimationPlayer = null
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

# Pitch and Yaw angles
var camera_pitch: float = -10.0
var camera_yaw: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_health = max_health

	# Locate AnimationPlayer within ModelRoot
	_find_animation_player()

	if spring_arm:
		spring_arm.spring_length = default_arm_length
	if camera:
		camera.fov = default_fov

func _find_animation_player() -> void:
	if model_root:
		animation_player = _search_for_anim_player(model_root)
		if animation_player:
			print("PlayerController3D: Found AnimationPlayer with %d animations" % animation_player.get_animation_list().size())

func _search_for_anim_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var found = _search_for_anim_player(child)
		if found:
			return found
	return null

func _unhandled_input(event: InputEvent) -> void:
	if not is_alive:
		return

	# Mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_yaw -= event.relative.x * mouse_sensitivity
		camera_pitch -= event.relative.y * mouse_sensitivity
		camera_pitch = clampf(camera_pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

		camera_pivot.rotation.y = camera_yaw
		camera_pivot.rotation.x = camera_pitch

	# Toggle mouse capture with ESC
	if event.is_action_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	_handle_input_states()
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement(delta)
	_handle_aim_down_sights(delta)
	_update_character_rotation(delta)
	_update_animations()

	move_and_slide()

func _handle_input_states() -> void:
	is_aiming = Input.is_action_pressed("aim_down_sights")
	is_crouching = Input.is_action_pressed("crouch") and not is_aiming
	is_sprinting = Input.is_action_pressed("sprint") and not is_aiming and not is_crouching and is_on_floor()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_crouching:
		velocity.y = jump_velocity

func _handle_movement(delta: float) -> void:
	var input_vec = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	# Calculate camera-relative movement direction
	var cam_transform = camera_pivot.global_transform
	var forward = -cam_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()

	var right = cam_transform.basis.x
	right.y = 0.0
	right = right.normalized()

	var target_dir = (right * input_vec.x + forward * -input_vec.y).normalized()

	# Determine target speed
	var target_speed = walk_speed
	if is_crouching:
		target_speed = crouch_speed
	elif is_sprinting and target_dir.length_squared() > 0.01:
		target_speed = sprint_speed
	elif is_aiming:
		target_speed = walk_speed * 0.7

	var target_velocity = target_dir * target_speed
	velocity.x = lerpf(velocity.x, target_velocity.x, acceleration * delta)
	velocity.z = lerpf(velocity.z, target_velocity.z, acceleration * delta)

func _handle_aim_down_sights(delta: float) -> void:
	var target_fov = ads_fov if is_aiming else default_fov
	var target_arm = ads_arm_length if is_aiming else default_arm_length

	if camera:
		camera.fov = lerpf(camera.fov, target_fov, 10.0 * delta)
	if spring_arm:
		spring_arm.spring_length = lerpf(spring_arm.spring_length, target_arm, 10.0 * delta)

func _update_character_rotation(delta: float) -> void:
	if not model_root:
		return

	if is_aiming:
		# When aiming, character body faces exactly where camera looks
		var target_rotation_y = camera_pivot.rotation.y
		model_root.rotation.y = lerp_angle(model_root.rotation.y, target_rotation_y, rotation_speed * 1.5 * delta)
	else:
		# When exploring/moving, character body rotates smoothly towards movement direction
		var horizontal_velocity = Vector2(velocity.x, velocity.z)
		if horizontal_velocity.length_squared() > 0.2:
			var target_angle = -horizontal_velocity.angle() + PI / 2.0
			model_root.rotation.y = lerp_angle(model_root.rotation.y, target_angle, rotation_speed * delta)

func _update_animations() -> void:
	if not animation_player:
		return

	var horizontal_speed = Vector2(velocity.x, velocity.z).length()

	if not is_on_floor():
		if velocity.y > 0.5:
			_play_animation("jump_2_upwards", 0.15)
		else:
			_play_animation("jump_4_falling", 0.15)
		return

	if horizontal_speed < 0.2:
		if is_aiming:
			_play_animation("Idlecombat", 0.2)
		else:
			_play_animation("Idle", 0.2)
	elif is_sprinting:
		_play_animation("running_gun", 0.15)
	else:
		if is_aiming:
			_play_animation("strafe_front", 0.15)
		else:
			_play_animation("running_nogun", 0.2)

func _play_animation(anim_name: String, blend_time: float) -> void:
	if not animation_player:
		return

	if animation_player.has_animation(anim_name):
		if animation_player.current_animation != anim_name:
			animation_player.play(anim_name, blend_time)
	elif animation_player.has_animation("Idle"):
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle", blend_time)

func take_damage(amount: int, _source: Node = null) -> void:
	if not is_alive:
		return

	current_health = maxi(0, current_health - amount)
	health_changed.emit(current_health, max_health)

	if current_health <= 0:
		is_alive = false
		_play_animation("jump_5_hardlanding", 0.2)
		died.emit()

