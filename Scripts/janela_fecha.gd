extends Area2D

@onready var label = $Label
@onready var background: TextureRect = get_parent()
@onready var nada = preload("res://Imagens/Cenários Jogo/Corredor - Janela close.png")
@onready var jan1 = preload("res://Imagens/Cenários Jogo/Monstro Janela.png")
@onready var jan2 = preload("res://Imagens/Cenários Jogo/Monstro Janela 2.png")
@onready var jan3 = preload("res://Imagens/Cenários Jogo/Monstro Janela 3.png")

var pressionando = false
var cap = 2.0
var back = "nada"

func _process(delta):
	if (pressionando == true):
		if (Global.janela_pause == false):
			SonsController.janela_tocar(Global.volume_janela)
			Global.janela_pause = true
		Global.janela_liberar += delta
		if (Global.janela_liberar >= cap):
			Global.janela_liberar = 0.0
			Global.janela -= 1
	elif (Global.janela_pause == true):
		SonsController.janela_stop()
		Global.janela_pause = false
	if (back != "jan1" and Global.janela == 1):
		back = "jan1"
		background.texture = jan1
		label.visible = true
	if (back != "jan2" and Global.janela == 2):
		back = "jan2"
		background.texture = jan2
		label.visible = true
	if (back != "jan3" and Global.janela == 3):
		back = "jan3"
		background.texture = jan3
		label.visible = true
	if (back != "nada" and (Global.janela == 0 or Global.janela == 4)):
		back = "nada"
		background.texture = nada
		label.visible = false
	
func _on_mouse_entered():
	label.add_theme_color_override("font_color", Color8(168, 17, 0))
	label.add_theme_font_size_override("font_size", 50)

func _on_mouse_exited():
	label.add_theme_color_override("font_color", Color8(142, 10, 0))
	label.add_theme_font_size_override("font_size", 45)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if Global.janela > 0:
			pressionando = event.pressed  # true ao pressionar, false ao soltar
		if Global.dopel == 2 and event.pressed:
			print("morreu dopel janela")
			Global.morrer()
