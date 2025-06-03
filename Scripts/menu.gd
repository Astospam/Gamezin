extends Area2D

@onready var label = $Label
@onready var labele = $Label2

func _ready():
	await get_tree().process_frame
	apos_ready()
		
func apos_ready():
	print("Executado depois do _ready()")
	if (get_meta("state") == 1):
		labele.text = "Noite " + str(Global.ultnoite)
		set_meta("noite", Global.ultnoite)
	elif (get_meta("state") == 2 or get_meta("state") == 0):
		labele.visible = false
	
func _on_mouse_entered():
	label.add_theme_color_override("font_color", Color8(168, 17, 0))
	label.add_theme_font_size_override("font_size", 50)

func _on_mouse_exited():
	label.add_theme_color_override("font_color", Color8(142, 10, 0))
	label.add_theme_font_size_override("font_size", 45)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if (get_meta("state") == 0 or get_meta("state") == 1):
			Global.local = "computador"
			Global.comecar_noite(get_meta("noite"))
			get_tree().change_scene_to_file("res://Scenes/computador.tscn")
		else:
			Global.local = "menu"
			SonsController.stop_all()
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		
