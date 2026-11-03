# Weapon Component
# Handles firing rate, projectile instantiation, magazine capacity, and reload cycles
class_name Weapon
extends Node2D

signal ammo_changed(current_ammo: int, max_clip: int)
signal reload_started(duration: float)
signal reload_finished()
signal fired()

@export var weapon_id: String = "pistol"
var weapon_name: String = "Standard Pistol"
var fire_rate: float = 3.0 # Rounds per second
var damage: int = 20
var magazine_size: int = 12
var reload_time: float = 1.2
var bullet_speed: float = 800.0
var bullet_range: float = 600.0
var spread: float = 2.0 # Degrees
var pellets: int = 1

var current_ammo: int = 12
var is_reloading: bool = false
var _fire_timer: float = 0.0
var _reload_timer: float = 0.0

var projectile_scene: PackedScene = preload("res://scenes/combat/projectile.tscn")

func _ready() -> void:
	load_weapon_stats(weapon_id)

func load_weapon_stats(id: String) -> void:
	weapon_id = id
	var data_loader = get_node_or_null("/root/GameDataLoader")
	if data_loader and data_loader.has_method("get_weapon"):
		var data = data_loader.get_weapon(id)
		weapon_name = data.get("name", id.capitalize())
		fire_rate = float(data.get("fireRate", 3.0))
		damage = int(data.get("damage", 20))
		magazine_size = int(data.get("magazineSize", 12))
		reload_time = float(data.get("reloadTime", 1.2))
		bullet_speed = float(data.get("bulletSpeed", 800.0))
		bullet_range = float(data.get("bulletRange", 600.0))
		spread = float(data.get("spread", 2.0))
		pellets = int(data.get("pellets", 1))

	current_ammo = magazine_size
	is_reloading = false
	_reload_timer = 0.0
	_fire_timer = 0.0
	ammo_changed.emit(current_ammo, magazine_size)

func _process(delta: float) -> void:
	if _fire_timer > 0.0:
		_fire_timer = maxf(0.0, _fire_timer - delta)

	if is_reloading:
		_reload_timer -= delta
		if _reload_timer <= 0.0:
			_finish_reload()

func can_fire() -> bool:
	return not is_reloading and _fire_timer <= 0.0 and current_ammo > 0

func fire(shooter: Node, muzzle_pos: Vector2, aim_dir: Vector2, container: Node) -> bool:
	if is_reloading:
		return false

	if current_ammo <= 0:
		start_reload()
		return false

	if _fire_timer > 0.0:
		return false

	_fire_timer = 1.0 / maxf(0.01, fire_rate)
	current_ammo -= 1
	ammo_changed.emit(current_ammo, magazine_size)

	var base_angle = aim_dir.angle()

	for i in range(pellets):
		var spread_angle = deg_to_rad(randf_range(-spread, spread))
		var shot_dir = Vector2.from_angle(base_angle + spread_angle)

		var bullet = projectile_scene.instantiate() as Projectile
		container.add_child(bullet)
		bullet.setup(shooter, muzzle_pos, shot_dir, bullet_speed, damage, bullet_range)

	fired.emit()
	var audio_mgr = get_node_or_null("/root/AudioManager")
	if audio_mgr and audio_mgr.has_method("play_sfx"):
		audio_mgr.play_sfx("shoot", randf_range(0.95, 1.05))

	if current_ammo <= 0:
		start_reload()

	return true

func start_reload() -> void:
	if is_reloading or current_ammo == magazine_size:
		return

	is_reloading = true
	_reload_timer = reload_time
	reload_started.emit(reload_time)
	var audio_mgr = get_node_or_null("/root/AudioManager")
	if audio_mgr and audio_mgr.has_method("play_sfx"):
		audio_mgr.play_sfx("reload", 1.0)

func _finish_reload() -> void:
	is_reloading = false
	current_ammo = magazine_size
	ammo_changed.emit(current_ammo, magazine_size)
	reload_finished.emit()

func cancel_reload() -> void:
	if is_reloading:
		is_reloading = false
		_reload_timer = 0.0
