extends Area2D

@onready var bliack = $Bliack

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("APEROT")
		if (Global.pausado == false and Global.resetando == false):
			bliack.visible = true
			Global.resetando = true
			await get_tree().create_timer(5.0).timeout
			Global.projetos = true
			Global.engines_menu = false
			Global.invadindo = false
			Global.invasor = 0
			SonsController.invasor_stop()
			bliack.visible = false
			Global.resetando = false
			
