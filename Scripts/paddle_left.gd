extends CharacterBody2D

const SPEED = 300

func _physics_process(delta):
	var input = 0
	if Input.is_action_pressed("ui_up"):
		input -= 1
	if Input.is_action_pressed("ui_down"):
		input += 1
	velocity.y = input * SPEED
	move_and_slide()
