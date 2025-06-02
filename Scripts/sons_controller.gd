extends Node

@onready var playerr = $BaterRecep
@onready var playerd = $Dopel
@onready var playerj = $JanelaSound

func tocar_recep(volume: float):
	playerr.stream = load("res://Audios/Sons/demonio recepcao audiocue.ogg")
	playerr.volume_db = volume
	playerr.play()
	
func set_volume_recep(volume: float):
	playerr.volume_db = volume
	
func dopel_laugh():
	playerd.stream = load("res://Audios/Sons/Doppelganger-Audio-cue.ogg")
	playerd.play()

func janela_tocar():
	playerj.stream = load("res://Audios/Sons/Rangido-Janela.ogg")
	playerj.play()

func janela_stop():
	playerj.stop()
