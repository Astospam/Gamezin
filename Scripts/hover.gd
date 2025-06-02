extends Area2D

@onready var label = $Label

func _on_mouse_entered():
	label.add_theme_color_override("font_color", Color8(168, 17, 0))
	label.add_theme_font_size_override("font_size", 50)

func _on_mouse_exited():
	label.add_theme_color_override("font_color", Color8(142, 10, 0))
	label.add_theme_font_size_override("font_size", 45)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Global.local = get_meta("Lugar")
		
		if (Global.local in Global.ter):
			if (Global.local == "recepcao"):
				Global.volume_recep = 0
			else:
				Global.volume_recep = -4.0
			Global.volume_radio = -27.0
			Global.volume_janela = -18.0
			
			
		if (Global.local in Global.pis1):
			Global.volume_recep = -9.0
			Global.volume_radio = -18.0
			Global.volume_janela = -9.0
			
			
		if (Global.local in Global.pis2):
			Global.volume_recep = -16.0
			if (Global.local == "computador"):
				Global.volume_radio = 0
			elif (Global.local == "gamelab"):
				Global.volume_radio = -4.0
			else:
				Global.volume_radio = -9.0
			if (Global.local == "janela"):
				Global.volume_janela = 0
			elif (Global.local == "corredor_janela"):
				Global.volume_janela = -2.0
			else:
				Global.volume_janela = -5.0
				
				
		if (Global.local in Global.pis3):
			Global.volume_recep = -27.0
			Global.volume_radio = -18.0
			Global.volume_janela = -9.0
			
		get_tree().change_scene_to_file("res://Scenes/" + get_meta("Lugar") + ".tscn")
		SonsController.set_volume_recep(0)
		SonsController.set_volume_recep(Global.volume_recep)
		SonsController.radio_volume(0)
		SonsController.radio_volume(Global.volume_radio)
		SonsController.janela_volume(0)
		SonsController.janela_volume(Global.volume_janela)
