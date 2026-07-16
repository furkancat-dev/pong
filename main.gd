extends Node2D
		
func _input(event) -> void:
	if event.is_action_pressed("ui_accept"):
		get_window().size = Vector2(800, 600)
