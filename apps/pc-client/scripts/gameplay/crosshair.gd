# Crosshair Component
# Tactical HUD crosshair drawn procedurally at the player's mouse position
class_name Crosshair
extends Control

@export var crosshair_color: Color = Color(0.2, 0.9, 1.0, 0.85)
@export var center_dot_radius: float = 2.0
@export var line_length: float = 8.0
@export var line_distance: float = 5.0

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	# Center pip
	draw_circle(Vector2.ZERO, center_dot_radius, crosshair_color)

	# 4 Cross lines (Up, Down, Left, Right)
	draw_line(Vector2(0, -line_distance), Vector2(0, -line_distance - line_length), crosshair_color, 1.5)
	draw_line(Vector2(0, line_distance), Vector2(0, line_distance + line_length), crosshair_color, 1.5)
	draw_line(Vector2(-line_distance, 0), Vector2(-line_distance - line_length, 0), crosshair_color, 1.5)
	draw_line(Vector2(line_distance, 0), Vector2(line_distance + line_length, 0), crosshair_color, 1.5)

