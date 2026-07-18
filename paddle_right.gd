extends PaddleBase

func _physics_process(_delta) -> void:
	velocity.y = Input.get_axis("ui_up", "ui_down") * speed
	
	move_and_slide()
