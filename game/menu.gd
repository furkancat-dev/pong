extends Label

func _input(event) -> void:
	if event.is_action_pressed("start_game"):
		get_tree().change_scene_to_file("res://game/game.tscn")
