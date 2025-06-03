extends Area2D

@onready var pong = $Pong

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if (Global.pausado == false and Global.resetando == false):
			print("APEROT")
			Global.pongon = true
			pong.visible = true
