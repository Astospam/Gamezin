extends Control

@onready var background: TextureRect = get_parent()

@onready var terceiro_norm = preload("res://Imagens/Cenários Jogo/Terceiro piso.png")
@onready var terceiro_elev_1 = preload("res://Imagens/Cenários Jogo/Monstro do Elevador - Terceiro piso 1.png")
@onready var terceiro_elev_2 = preload("res://Imagens/Cenários Jogo/Monstro do Elevador - Terceiro piso 2.png")

@onready var incendio_norm = preload("res://Imagens/Cenários Jogo/Corredor - saída de incêndio.png")
@onready var incendio_elev_1 = preload("res://Imagens/Cenários Jogo/Monstro do Elevador - Saída de incêndio 1.png")
@onready var incendio_elev_2 = preload("res://Imagens/Cenários Jogo/Monstro do Elevador - Saída de incêndio 2.png")

@onready var corredor_norm = preload("res://Imagens/Cenários Jogo/Corredor-janela.png")
@onready var corredor_norm_aberto = preload("res://Imagens/Cenários Jogo/Corredor - janela aberta.png")
@onready var corredor_elev = preload("res://Imagens/Cenários Jogo/Monstro do Elevador - Corredor gamelab.png")


func _process(delta):
	if (Global.elevador_local != "elevador"):
		match Global.local:
			"terceiro_piso":
				if (Global.elevador_local == "terceiro_piso"):
					if (Global.elevador_varia == 1 and background.texture != terceiro_elev_1):
						background.texture = terceiro_elev_1
					if (Global.elevador_varia == 2 and background.texture != terceiro_elev_2):
						background.texture = terceiro_elev_2
				else:
					if (background.texture != terceiro_norm):
						background.texture = terceiro_norm
			"corredor_janela":
				if (Global.elevador_local == "corredor_janela" and background.texture != corredor_elev):
					background.texture = corredor_elev
				else:
					if (Global.janela == 0 or Global.janela == 4):
						if (background.texture != corredor_norm):
							background.texture = corredor_norm
					else:
						if (background.texture != corredor_norm_aberto):
							background.texture = corredor_norm_aberto
			"saida_incendio":
				if (Global.elevador_local == "saida_incendio"):
					if (Global.elevador_varia == 1 and background.texture != incendio_elev_1):
						background.texture = incendio_elev_1
					if (Global.elevador_varia == 2 and background.texture != incendio_elev_2):
						background.texture = incendio_elev_2
				else:
					if (background.texture != incendio_norm):
						background.texture = incendio_norm
