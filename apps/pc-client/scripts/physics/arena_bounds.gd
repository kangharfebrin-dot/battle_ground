# Arena Bounds & Obstacles Generator
# Builds StaticBody2D boundaries and obstacle collisions based on arena configuration
class_name ArenaBounds
extends Node2D

@export var arena_width: float = 1600.0
@export var arena_height: float = 1200.0
@export var wall_thickness: float = 32.0

var obstacles_data: Array = []

func _ready() -> void:
	_load_arena_data()
	_create_boundary_walls()
	_create_obstacles()
	queue_redraw()

func _load_arena_data() -> void:
	var data_loader = get_node_or_null("/root/GameDataLoader")
	if data_loader and data_loader.has_method("get_arena_data"):
		var data = data_loader.get_arena_data()
		if data.has("bounds"):
			arena_width = float(data["bounds"].get("width", 1600.0))
			arena_height = float(data["bounds"].get("height", 1200.0))
		if data.has("obstacles"):
			obstacles_data = data["obstacles"]

func _create_boundary_walls() -> void:
	var walls_body = StaticBody2D.new()
	walls_body.name = "BoundaryWalls"
	walls_body.collision_layer = 2 # Walls layer
	walls_body.collision_mask = 5  # Collide with player and projectiles
	add_child(walls_body)

	# Top Wall
	_add_wall_shape(walls_body, Vector2(arena_width / 2.0, -wall_thickness / 2.0), Vector2(arena_width + wall_thickness * 2, wall_thickness))
	# Bottom Wall
	_add_wall_shape(walls_body, Vector2(arena_width / 2.0, arena_height + wall_thickness / 2.0), Vector2(arena_width + wall_thickness * 2, wall_thickness))
	# Left Wall
	_add_wall_shape(walls_body, Vector2(-wall_thickness / 2.0, arena_height / 2.0), Vector2(wall_thickness, arena_height))
	# Right Wall
	_add_wall_shape(walls_body, Vector2(arena_width + wall_thickness / 2.0, arena_height / 2.0), Vector2(wall_thickness, arena_height))

func _create_obstacles() -> void:
	var obstacles_body = StaticBody2D.new()
	obstacles_body.name = "Obstacles"
	obstacles_body.collision_layer = 2
	obstacles_body.collision_mask = 5
	add_child(obstacles_body)

	for obs in obstacles_data:
		var ox = float(obs.get("x", 0))
		var oy = float(obs.get("y", 0))
		var ow = float(obs.get("width", 60))
		var oh = float(obs.get("height", 60))
		_add_wall_shape(obstacles_body, Vector2(ox, oy), Vector2(ow, oh))

func _add_wall_shape(body: StaticBody2D, center: Vector2, size: Vector2) -> void:
	var col = CollisionShape2D.new()
	var box = RectangleShape2D.new()
	box.size = size
	col.shape = box
	col.position = center
	body.add_child(col)

func _draw() -> void:
	# Background arena floor
	draw_rect(Rect2(0, 0, arena_width, arena_height), Color(0.12, 0.14, 0.18))

	# Grid lines (every 100px)
	var grid_color = Color(0.18, 0.22, 0.28, 0.5)
	for x in range(0, int(arena_width) + 1, 100):
		draw_line(Vector2(x, 0), Vector2(x, arena_height), grid_color, 1.0)
	for y in range(0, int(arena_height) + 1, 100):
		draw_line(Vector2(0, y), Vector2(arena_width, y), grid_color, 1.0)

	# Arena Outer Border
	draw_rect(Rect2(0, 0, arena_width, arena_height), Color(0.3, 0.6, 0.9, 0.8), false, 4.0)

	# Obstacles Visuals
	for obs in obstacles_data:
		var ox = float(obs.get("x", 0))
		var oy = float(obs.get("y", 0))
		var ow = float(obs.get("width", 60))
		var oh = float(obs.get("height", 60))
		var rect = Rect2(ox - ow / 2.0, oy - oh / 2.0, ow, oh)
		draw_rect(rect, Color(0.25, 0.28, 0.35))
		draw_rect(rect, Color(0.45, 0.52, 0.65), false, 2.0)
