extends Control

@onready var label = $Label

func _ready():
	var tempo = Global.tempo_decorrido
	label.text = formatar_tempo(tempo)

func _process(delta):
	var tempo = Global.tempo_decorrido
	label.text = formatar_tempo(tempo)

func formatar_tempo(segundos:float) -> String:
	var total = int(segundos)
	var minutos = (total % 3600)/60
	var segundos_restantes = total % 60
	
	return "%02d:%02d" % [minutos, segundos_restantes]
	
