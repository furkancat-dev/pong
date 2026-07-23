extends Control

func _input(event) -> void:
	if event.is_action_pressed("start_game"):
		AudioManager.play_ui_click()
		get_tree().change_scene_to_file("res://game/game.tscn")
