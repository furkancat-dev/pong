extends PaddleBase

@onready var ball_target: Node2D = $"../Ball/CollisionShape2D"
@export var bot_speed := 300.0
@export var dead_zone := 15.0

func _physics_process(_delta) -> void:
	# I will add an option - play with AI and play with your friend
	# keep this code for now
	#velocity.y = Input.get_axis("left_up", "left_down") * speed
	
	var difference_y := ball_target.global_position.y - global_position.y
	
	if abs(difference_y) < dead_zone:
		velocity.y = 0
	else:
		velocity.y = sign(difference_y) * bot_speed
		
	move_and_slide()
