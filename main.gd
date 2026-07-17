extends Node2D

@onready var ball_node := $Ball

func _ready():
	ball_node.ball_exited.connect(_on_ball_exited)
		
#func _input(event) -> void:
	#if event.is_action_pressed("ui_accept"):
		#get_window().size = Vector2(800, 600)

func _on_ball_exited(side: String) -> void:
	print('DONE', side)
