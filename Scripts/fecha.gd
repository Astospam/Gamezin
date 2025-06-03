extends Area2D

@onready var label = $Label
@onready var background: TextureRect = get_parent()

@onready var elevA = preload("res://Imagens/Cenários Jogo/Elevador Térreo.png")
@onready var elevB = preload("res://Imagens/Cenários Jogo/Elevador Térreo - porta aberta.png")

@onready var elev1A = preload("res://Imagens/Cenários Jogo/Elevador primeiro piso.png")
@onready var elev1B = preload("res://Imagens/Cenários Jogo/Elevador primeiro piso - porta aberta.png")

@onready var elev2A = preload("res://Imagens/Cenários Jogo/Piso 2 - Elevador.png")
@onready var elev2B = preload("res://Imagens/Cenários Jogo/Piso 2 - Elevador porta aberta.png")

@onready var elev3A = preload("res://Imagens/Cenários Jogo/Piso 3 - Elevador.png")
@onready var elev3B = preload("res://Imagens/Cenários Jogo/Piso 3 - Elevador porta aberta.png")


func _process(delta):
	if (Global.elevador != 0 and Global.elevador_local == "elevador"):
		label.visible = true
	else:
		label.visible = false
	match Global.local:
		"elevador_terreo":
			if (Global.elevador == 0):
				background.texture = elevA
			else:
				background.texture = elevB
		"elevador_1":
			if (Global.elevador == 0):
				background.texture = elev1A
			else:
				background.texture = elev1B
		"elevador_2":
			if (Global.elevador == 0):
				background.texture = elev2A
			else:
				background.texture = elev2B
		"elevador_3":
			if (Global.elevador == 0):
				background.texture = elev3A
			else:
				background.texture = elev3B
		

func _on_mouse_entered():
	label.add_theme_color_override("font_color", Color8(168, 17, 0))
	label.add_theme_font_size_override("font_size", 50)

func _on_mouse_exited():
	label.add_theme_color_override("font_color", Color8(142, 10, 0))
	label.add_theme_font_size_override("font_size", 45)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if (Global.elevador != 0 and Global.elevador_local == "elevador"):
			Global.elevador_set()
			SonsController.elevador_stop()
			print("elevador se torou")
