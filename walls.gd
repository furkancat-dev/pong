extends Node

@export var wall_thickness := 20.0

@onready var top_collision: CollisionShape2D = $Top/CollisionShape2D
@onready var bottom_collision: CollisionShape2D = $Bottom/CollisionShape2D

func _ready() -> void:
	_update_walls()
	get_viewport().size_changed.connect(_update_walls)

func _update_walls() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var wall_size := Vector2(viewport_size.x, wall_thickness)
	var top_shape := top_collision.shape as RectangleShape2D
	var bottom_shape := bottom_collision.shape as RectangleShape2D
	
	top_shape.size = wall_size
	top_collision.position = Vector2(viewport_size.x / 2.0, 0)
	
	bottom_shape.size = wall_size
	bottom_collision.position = Vector2(viewport_size.x / 2.0, viewport_size.y)
