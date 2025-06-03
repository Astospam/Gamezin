extends CharacterBody2D

var base_speed = 300
var current_speed = base_speed
var speed_increase_percent = 0.1  # 10% de aumento por rebatida
var max_speed = 800  # Velocidade máxima
var direction = Vector2(1, 0.5).normalized()

func _physics_process(delta):
	if (Global.pongon == true):
		velocity = direction * current_speed
		var collision = move_and_collide(velocity * delta)
		
		if collision:
			direction = direction.bounce(collision.get_normal())
			
			# Aumento percentual (mais balanceado)
			current_speed = min(current_speed * (1 + speed_increase_percent), max_speed)
			
			if collision.get_collider().is_in_group("paddles"):
				var paddle = collision.get_collider()
				var collision_shape = paddle.get_node("CollisionShape2D")
				if collision_shape.shape is RectangleShape2D:
					var paddle_height = collision_shape.shape.size.y
					var hit_position = (position.y - paddle.position.y) / (paddle_height / 2)
					direction.y = hit_position * (0.5 + current_speed/max_speed * 0.3)  # Ângulo fica mais acentuado com a velocidade
					direction = direction.normalized()
			
			if collision.get_collider().is_in_group("reset"):
				reset_element()
	else:
		get_parent().get_parent().visible = false

			
func reset_ball():
	current_speed = base_speed
	direction = Vector2(1, 0.5).normalized()
	position = Vector2(640, 360)  # Posição central (ajuste conforme seu layout)
	

func reset_element():
	get_tree().change_scene_to_file("res://Scenes/" + Global.local + ".tscn")
	
