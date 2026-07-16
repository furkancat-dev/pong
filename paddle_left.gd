extends PaddleBase

# get access to the ball nodew
@onready var ball_node: CharacterBody2D = $"../Ball"

func _physics_process(_delta) -> void:
	#velocity.y = Input.get_axis("left_up", "left_down") * speed
	
	# ball node unu alip pozisyon bilgisi ile bot icin paddle konumlandirma
	var dif = ball_node.global_position.y - global_position.y
	
	if dif < -10.0:
		#move up
		velocity.y = -speed
	elif dif > 0:
		#move down
		velocity.y = speed
	else:
		velocity.y = 0
	move_and_slide()
