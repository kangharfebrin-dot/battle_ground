# 3D Tactical Shooter HUD Controller
# Military-grade UI: HP bar, 360-degree compass heading, crosshair, ammo counter, and stance
class_name HUD3D
extends CanvasLayer

@onready var health_bar: ProgressBar = $RootMargin/VBoxBottomLeft/HealthBar
@onready var health_label: Label = $RootMargin/VBoxBottomLeft/HealthLabel
@onready var stance_label: Label = $RootMargin/VBoxBottomLeft/StanceLabel
@onready var compass_label: Label = $TopCenter/CompassLabel
@onready var ammo_label: Label = $RootMargin/VBoxBottomRight/AmmoLabel
@onready var weapon_label: Label = $RootMargin/VBoxBottomRight/WeaponLabel
@onready var crosshair: Control = $CenterCrosshair

var target_player: PlayerController3D = null

func setup(player: PlayerController3D) -> void:
	target_player = player
	if target_player:
		target_player.health_changed.connect(_on_health_changed)
		_on_health_changed(target_player.current_health, target_player.max_health)

func _process(_delta: float) -> void:
	if not target_player:
		return

	# Update 360-degree compass heading
	var cam_yaw = target_player.camera_pivot.rotation.y
	var degrees = fposmod(rad_to_deg(-cam_yaw), 360.0)
	var cardinal = _get_cardinal_direction(degrees)
	if compass_label:
		compass_label.text = "[ %03d° %s ]" % [int(degrees), cardinal]

	# Update stance
	if stance_label:
		if target_player.is_aiming:
			stance_label.text = "STANCE: ADS / AIM"
			stance_label.modulate = Color(1.0, 0.8, 0.2)
		elif target_player.is_sprinting:
			stance_label.text = "STANCE: SPRINTING"
			stance_label.modulate = Color(0.4, 0.9, 1.0)
		elif target_player.is_crouching:
			stance_label.text = "STANCE: CROUCHED"
			stance_label.modulate = Color(0.8, 0.8, 0.8)
		else:
			stance_label.text = "STANCE: STANDING"
			stance_label.modulate = Color(0.9, 0.9, 0.9)

func _get_cardinal_direction(deg: float) -> String:
	if deg >= 337.5 or deg < 22.5:
		return "N"
	elif deg >= 22.5 and deg < 67.5:
		return "NE"
	elif deg >= 67.5 and deg < 112.5:
		return "E"
	elif deg >= 112.5 and deg < 157.5:
		return "SE"
	elif deg >= 157.5 and deg < 202.5:
		return "S"
	elif deg >= 202.5 and deg < 247.5:
		return "SW"
	elif deg >= 247.5 and deg < 292.5:
		return "W"
	else:
		return "NW"

func _on_health_changed(current: int, max_hp: int) -> void:
	if health_bar:
		health_bar.max_value = max_hp
		health_bar.value = current
	if health_label:
		health_label.text = "HP: %d / %d" % [current, max_hp]

