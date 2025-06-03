extends Area2D

@onready var engi = $Enginer
@onready var botnov = $Enginer/NovoJogo # Este é o botão "Novo Jogo"

func _ready():
	# NÃO COLOQUE NENHUMA ATRIBUIÇÃO DIRETA DE Global.projetos ou Global.engines_menu AQUI.
	# Esses valores virão diretamente do Singleton Global, que foi resetado.
	
	# Sincroniza a visibilidade inicial com os valores do Global.gd
	# Se Global.engines_menu for false (que é o padrão após o reset), engi (Enginer) ficará invisível.
	engi.visible = Global.engines_menu
	
	# Se Global.projetos for true e Global.engines_menu for false, botnov (NovoJogo) ficará invisível.
	botnov.visible = Global.projetos and Global.engines_menu
	
	print("--- ENGINEIRO.gd _ready() executado ---")
	print("Cena carregada - Enginer visível:", engi.visible)
	print("Estado Global - projetos:", Global.projetos, ", engines_menu:", Global.engines_menu)
	
	# Habilite o processamento de input
	set_process_input(true)
	# Verifique a camada/máscara de colisão para depuração
	print("Camadas de colisão:", collision_layer)
	print("Máscara de colisão:", collision_mask)


func _process(delta):
	# Continua a garantir que a visibilidade do botão Novo Jogo seja atualizada
	# caso Global.engines_menu mude.
	botnov.visible = Global.projetos and Global.engines_menu

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("--- Clique no ENGINEIRO ---")
		print("Global.engines_menu ANTES do clique:", Global.engines_menu)
		
		# Apenas alterna a visibilidade se o Enginer estiver atualmente escondido
		if (Global.engines_menu == false):
			engi.visible = true # Torna o Enginer (e seus filhos, os botões) visível
			Global.engines_menu = true # Atualiza o estado global
			print("Enginer tornou-se visível e Global.engines_menu agora é:", Global.engines_menu)
		# Se já estiver true (já foi clicado), não faz nada.
		else:
			print("Enginer já estava visível. Nenhum estado alterado.")
