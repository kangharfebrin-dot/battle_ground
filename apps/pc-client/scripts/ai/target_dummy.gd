# Target Dummy
# Practice target for weapon testing and arena combat validation
class_name TargetDummy
extends CharacterBody2D

signal dummy_destroyed(dummy: Node2D)

@onready var health: Health = $Health

var radius: float = 16.0
var is_flashing: bool = false
var flash_timer: float = 0.0
var flash_color: Color = Color(1.0, 0.3, 0.3)
var normal_color: Color = Color(0.85, 0.25, 0.25)
var respawn_timer: float = 0.0
var is_active: bool = true

func _ready() -> void:
	if health:
		health.damaged.connect(_on_damaged)
		health.died.connect(_on_died)
	queue_redraw()

func _process(delta: float) -> void:
	if is_flashing:
		flash_timer -= delta
		if flash_timer <= 0.0:
			is_flashing = false
			queue_redraw()

	if not is_active:
		respawn_timer -= delta
		if respawn_timer <= 0.0:
			_respawn()

func take_damage(amount: int, source: Node = null) -> void:
	if is_active and health:
		health.take_damage(amount, source)

func _on_damaged(_amount: int, _source: Node) -> void:
	is_flashing = true
	flash_timer = 0.1
	queue_redraw()

func _on_died() -> void:
	is_active = false
	respawn_timer = 3.0
	dummy_destroyed.emit(self)
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	queue_redraw()

func _respawn() -> void:
	is_active = true
	health.reset()
	set_collision_layer_value(2, true)
	queue_redraw()

func _draw() -> void:
	if not is_active:
		# Respawn timer outline
		draw_arc(Vector2.ZERO, radius, 0, TAU, 16, Color(0.5, 0.5, 0.5, 0.3), 2.0)
		return

	var col = flash_color if is_flashing else normal_color
	# Outer body
	draw_circle(Vector2.ZERO, radius, col)
	# Inner target ring
	draw_circle(Vector2.ZERO, radius * 0.6, Color.WHITE)
	# Bullseye
	draw_circle(Vector2.ZERO, radius * 0.25, col)

