extends TextureButton

@onready var back: TextureRect = get_parent() # <--- VERIFIQUE ISSO NOVAMENTE!!!
											# PROVAVELMENTE DEVE SER: @onready var back: TextureRect = $"../../Background"
@onready var norm = preload("res://Imagens/Cenários Jogo/Menu 2.png")
@onready var norm_c = preload("res://Imagens/Cenários Jogo/Computador menu 2.png")

func _on_pressed() -> void:
	print("--- Botão PROJETOS Clicado ---") # <--- NOVO PRINT
	print("Global.projetos:", Global.projetos, ", Global.engines_menu:", Global.engines_menu)

	if (Global.projetos == false and Global.engines_menu == true):
		Global.projetos = true
		if (Global.local == "menu"):
			if is_instance_valid(back): # Adicionado verificação de validade
				back.texture = norm
				print("Textura do background alterada para 'projetos' (menu).")
			else:
				print("ERRO: Nó 'back' (Background) não é válido!")
		else:
			if is_instance_valid(back):
				back.texture = norm_c
				print("Textura do background alterada para 'projetos' (jogo).")
			else:
				print("ERRO: Nó 'back' (Background) não é válido!")
	else:
		print("Condição para mudar para tela de projetos não satisfeita.")
