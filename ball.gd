extends CharacterBody2D

@export var speed := 400

var direction:= Vector2(1, 0.3).normalized()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		direction = direction.bounce(collision.get_normal())
