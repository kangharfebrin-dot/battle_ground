# Projectile
# Area2D representing bullets fired by player or enemies
class_name Projectile
extends Area2D

@export var speed: float = 800.0
@export var damage: int = 20
@export var max_range: float = 600.0

var shooter: Node = null
var distance_traveled: float = 0.0
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func setup(p_shooter: Node, p_pos: Vector2, p_dir: Vector2, p_speed: float, p_damage: int, p_range: float) -> void:
	shooter = p_shooter
	global_position = p_pos
	direction = p_dir.normalized()
	rotation = direction.angle()
	speed = p_speed
	damage = p_damage
	max_range = p_range

func _physics_process(delta: float) -> void:
	var move_dist = speed * delta
	global_position += direction * move_dist
	distance_traveled += move_dist

	if distance_traveled >= max_range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body == shooter:
		return

	# Check for health component or direct take_damage method
	if body.has_method("take_damage"):
		body.take_damage(damage, shooter)
	elif body.has_node("Health"):
		var health = body.get_node("Health") as Health
		if health:
			health.take_damage(damage, shooter)

	# Trigger audio feedback safely
	var audio_mgr = get_node_or_null("/root/AudioManager")
	if audio_mgr and audio_mgr.has_method("play_sfx"):
		audio_mgr.play_sfx("hit", randf_range(0.9, 1.1))

	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area == self or (shooter and area.is_ancestor_of(shooter)):
		return
	if area.has_method("take_damage"):
		area.take_damage(damage, shooter)
		queue_free()

func _draw() -> void:
	# Clean procedural bullet rendering (yellow-orange tracer)
	draw_circle(Vector2.ZERO, 3.5, Color(1.0, 0.85, 0.2))
	draw_line(Vector2(-6, 0), Vector2(0, 0), Color(1.0, 0.5, 0.1, 0.8), 2.5)
