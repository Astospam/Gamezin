extends Button

@onready var engi = get_parent() # engi aqui será o nó "Enginer"

func _on_pressed() -> void:
	print("--- Botão X Clicado ---") # <--- NOVO PRINT
	print("Global.projetos:", Global.projetos)
	print("Global.engines_menu:", Global.engines_menu)

	if (Global.engines_menu == true):
		engi.visible = false
		Global.engines_menu = false
		print("Enginer escondido e Global.engines_menu agora é:", Global.engines_menu)
	else:
		print("Menu Enginer já estava escondido.")
