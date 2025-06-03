extends Area2D

@onready var eng = $Engy
@onready var acesso = $Background/Acesso
@onready var pongy =  $Pongy
@onready var background = $Background

@onready var comp_norm = preload("res://Imagens/Cenários Jogo/Computador.png")
@onready var comp_inv = preload("res://Imagens/Cenários Jogo/Computador - invadido.png")

func _process(delta):
	if (Global.invadindo == true):
		if (background.texture != comp_inv):
			background.texture = comp_inv
	else:
		if (background.texture != comp_norm):
			background.texture = comp_norm


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("APEROT")
		if (Global.pausado == false and Global.pongon == false and Global.resetando == false and Global.invadindo == false):
			Global.pausado = true
			eng.visible = true
			acesso.visible = false
			SonsController.pause_radio()
		
