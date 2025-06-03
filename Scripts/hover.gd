extends Area2D

@onready var label = $Label

const elevadores = ["elevador_terreo", "elevador_1", "elevador_2", "elevador_3"]

func _on_mouse_entered():
	label.add_theme_color_override("font_color", Color8(168, 17, 0))
	label.add_theme_font_size_override("font_size", 50)

func _on_mouse_exited():
	label.add_theme_color_override("font_color", Color8(142, 10, 0))
	label.add_theme_font_size_override("font_size", 45)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if (Global.resetando == false):
			Global.prevlocal = Global.local
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
			
			if (Global.elevador != 0):
				match Global.local:
					"elevador_3":
						if (Global.elevador_local == "terceiro_piso" and Global.elevador_varia == 1):
							print("morreu elevador")
							Global.morrer()
							return
					"terreo":
						var eleve = elevadores.duplicate()
						eleve.erase("elevador_terreo")
						if (Global.prevlocal in eleve):
							print("morreu elevador")
							Global.morrer()
							return
					"primeiro_piso":
						var eleve1 = elevadores.duplicate()
						eleve1.erase("elevador_1")
						if ((Global.elevador_local == "saida_incendio" and Global.elevador_varia == 2 and Global.prevlocal == "saida_incendio") or (Global.prevlocal in eleve1)):
							print("morreu elevador")
							Global.morrer()
							return
					"segundo_piso":
						var eleve2 = elevadores.duplicate()
						eleve2.erase("elevador_2")
						if ((Global.elevador_local == "terceiro_piso" and Global.elevador_varia == 2 and Global.prevlocal == "terceiro_piso") or (Global.prevlocal in eleve2)):
							print("morreu elevador")
							Global.morrer()
							return
					"terceiro_piso":
						var eleve3 = elevadores.duplicate()
						eleve3.erase("elevador_3")
						if (Global.prevlocal in eleve3):
							print("morreu elevador")
							Global.morrer()
							return
					"janela":
						if (Global.elevador_local == "corredor_janela"):
							print("morreu elevador")
							Global.morrer()
							return
					"porta_incendio":
						if (Global.elevador_local == "saida_incendio" and Global.elevador_varia == 1):
							print("morreu elevador")
							Global.morrer()
							return
					
			Global.pongon = false	
			get_tree().change_scene_to_file("res://Scenes/" + get_meta("Lugar") + ".tscn")
			SonsController.set_volume_recep(0)
			SonsController.set_volume_recep(Global.volume_recep)
			SonsController.radio_volume(0)
			SonsController.radio_volume(Global.volume_radio)
			SonsController.janela_volume(0)
			SonsController.janela_volume(Global.volume_janela)
