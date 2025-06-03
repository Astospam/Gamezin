extends CharacterBody2D

const SPEED = 300
@onready var ball = get_node("../Ball")

func _physics_process(delta):
	if not ball:
		return
	
	if ball.position.y < position.y:
		velocity.y = -SPEED
	elif ball.position.y > position.y:
		velocity.y = SPEED
	else:
		velocity.y = 0

	move_and_slide()
