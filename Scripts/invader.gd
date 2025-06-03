extends Control


@onready var background: TextureRect = get_parent()

@onready var comp_norm = preload("res://Imagens/Cenários Jogo/Gamelab.png")
@onready var comp_inv = preload("res://Imagens/Cenários Jogo/Gamelab - Invadido.png")

func _process(delta):
	if (Global.invadindo == true):
		if (background.texture != comp_inv):
			background.texture = comp_inv
	else:
		if (background.texture != comp_norm):
			background.texture = comp_norm
