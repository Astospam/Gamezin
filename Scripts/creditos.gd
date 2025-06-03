extends TextureButton

@onready var back: TextureRect = get_parent() # <--- VERIFIQUE ISSO NOVAMENTE!!!
											# Se 'Background' é irmão de 'Engineiro',
											# e o botão é filho de 'Enginer' (que é filho de 'Engineiro'),
											# então 'get_parent()' pega 'Enginer', não 'Background'.
											# PROVAVELMENTE DEVE SER: @onready var back: TextureRect = $"../../Background"

@onready var cred = preload("res://Imagens/Cenários Jogo/Tela creditos.png")
@onready var cred_c = preload("res://Imagens/Cenários Jogo/Computador menu 3.png")

func _on_pressed() -> void:
	print("--- Botão CREDITOS Clicado ---") # <--- NOVO PRINT
	print("Global.projetos:", Global.projetos)
	print("Global.engines_menu:", Global.engines_menu)
	
	if (Global.projetos == true and Global.engines_menu == true):
		Global.projetos = false
		if (Global.local == "menu"):
			if is_instance_valid(back): # Adicionado verificação de validade
				back.texture = cred
				print("Textura do background alterada para 'créditos' (menu).")
			else:
				print("ERRO: Nó 'back' (Background) não é válido!")
		else:
			if is_instance_valid(back):
				back.texture = cred_c
				print("Textura do background alterada para 'créditos' (jogo).")
			else:
				print("ERRO: Nó 'back' (Background) não é válido!")
	else:
		print("Condição para alterar textura do crédito não satisfeita.")
