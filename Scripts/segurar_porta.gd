extends Area2D

@onready var label = $Label
@onready var background: TextureRect = get_parent()
@onready var progress = $ProgressBar
@onready var monster = preload("res://Imagens/Cenários Jogo/Recepção com bicho.png")
@onready var nada = preload("res://Imagens/Cenários Jogo/Recepção.png")
@onready var aberta = preload("res://Imagens/Cenários Jogo/Recepção - aberta.png")

var back = "nada"

func _process(delta):
	if (back == "nada" and Global.monster_recep == 1):
		back = "monster"
		background.texture = monster
		progress.visible = true
		label.text = "Segurar Porta"
	if (Global.monster_recep_aberta == true and back != "aberta"):
		back = "aberta"
		background.texture = aberta
		progress.visible = false
		label.text = "Fechar Porta"
	if (back != "nada" and Global.monster_recep == 0 and Global.monster_recep_aberta == false):
		back = "nada"
		background.texture = nada
		progress.visible = true
		label.text = "Segurar Porta"
		

func _on_mouse_entered():
	label.add_theme_color_override("font_color", Color8(168, 17, 0))
	label.add_theme_font_size_override("font_size", 50)

func _on_mouse_exited():
	label.add_theme_color_override("font_color", Color8(142, 10, 0))
	label.add_theme_font_size_override("font_size", 45)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if (Global.dopel == 1):
			print("morreu dopel")
			Global.morrer()
			return
		if (back == "monster"):
			progress.value += 1
			if (progress.value >= progress.max_value):
				progress.value = 0
				print("monstro se torou")
				Global.monster_reception_set()
		elif (back == "aberta"):
			Global.monster_recep_aberta = false
			back = "nada"
			background.texture = nada
			progress.value = 0
			label.text = "Segurar Porta"
			progress.visible = true
