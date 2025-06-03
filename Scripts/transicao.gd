extends CanvasLayer

@onready var anim = $AnimationPlayer
@onready var back = $TextureRect
@onready var anim2 = $AnimationPlayer2
@onready var jump = $Jumpscare
@onready var porta = $Jumpscare/TextureRect
@onready var elevador = $Jumpscare/TextureRect2
@onready var janela = $Jumpscare/TextureRect3

var cena_alvo: String

func _ready():
	# IMPORTANTE: Garante que o TextureRect (que cobre a tela) ignore cliques por padrão.
	# O CanvasLayer em si não tem a propriedade mouse_filter.
	back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	back.self_modulate.a = 0.0 # Garante que a transição comece invisível
	self.visible = false # Esconde o CanvasLayer inteiro quando não está em uso

func iniciar_transicao(cena: String, noite: int):
	# Torna o CanvasLayer visível
	self.visible = true
	# Faz o TextureRect interceptar cliques para bloquear a cena de baixo durante a transição
	back.mouse_filter = Control.MOUSE_FILTER_STOP

	match noite:
		1: back.texture = preload("res://Imagens/Cenários Jogo/Noite 1.png")
		2: back.texture = preload("res://Imagens/Cenários Jogo/Noite 2.png")
		3: back.texture = preload("res://Imagens/Cenários Jogo/Noite 3.png")
		4: back.texture = preload("res://Imagens/Cenários Jogo/Noite 4.png")
		5: back.texture = preload("res://Imagens/Cenários Jogo/Noite 5.png")

	cena_alvo = cena
	back.self_modulate.a = 0.0 # Começa invisível para a animação fade-in
	anim.play("fade")


# Conecte este sinal no editor Godot: AnimationPlayer -> Signals -> animation_finished()
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "fade":
		# Após a animação de fade-in (e antes do fade-out, se houver)
		get_tree().change_scene_to_file(cena_alvo)

		# IMPORTANTE: Desabilitar o CanvasLayer e permitir cliques APÓS A TROCA DE CENA.
		# Esconda o CanvasLayer e faça seu TextureRect ignorar cliques novamente.
		self.visible = false # Esconde o CanvasLayer novamente
		back.self_modulate.a = 0.0 # Garante transparência total
		back.mouse_filter = Control.MOUSE_FILTER_IGNORE # Permite cliques na nova cena

func jumpscare(bixo: int):
	self.visible = true
	# Faz o TextureRect interceptar cliques para bloquear a cena de baixo durante a transição
	back.mouse_filter = Control.MOUSE_FILTER_STOP
	
	match bixo:
		1:
			porta.visible = true
		2:
			elevador.visible = true
		3:
			janela.visible = true
			
	jump.visible = true
	SonsController.play_jumpscare()
	anim2.play("jumpscare")
	
			


func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jumpscare":
		print("finished")
		SonsController.stop_jumpscare()
		get_tree().change_scene_to_file("res://Scenes/morte.tscn")
		elevador.visible = false
		janela.visible = false
		porta.visible = false
		self.visible = false # Esconde o CanvasLayer novamente
		jump.visible = false
		back.mouse_filter = Control.MOUSE_FILTER_IGNORE
