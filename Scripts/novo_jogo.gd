extends TextureButton

func _on_pressed() -> void:
	print("--- Botão NOVO JOGO Clicado ---") # <--- NOVO PRINT
	print("Global.engines_menu:", Global.engines_menu, ", Global.projetos:", Global.projetos)

	if Global.engines_menu == true and Global.projetos == true:
		Global.local = "computador"
		Global.comecar_noite(5)
		Global.projetos = true
		Global.engines_menu = false # Esconde o menu Enginer ao entrar no jogo
		
		# Certifique-se de que Transicao é um AutoLoad válido
		if is_instance_valid(Transicao): # Adicionado verificação de validade
			Transicao.iniciar_transicao("res://Scenes/computador.tscn", Global.noite)
			print("Transição para computador.tscn iniciada.")
		else:
			print("ERRO: AutoLoad 'Transicao' não é válido!")
	else:
		print("Condição para iniciar novo jogo não satisfeita.")
