extends Node

@onready var playerr = $BaterRecep
@onready var playerd = $Dopel
@onready var playerj = $JanelaSound
@onready var player_ambi = $Ambient
@onready var player_radio = $Radio

func tocar_recep(volume: float):
	playerr.stream = load("res://Audios/Sons/demonio recepcao audiocue.ogg")
	playerr.volume_db = volume
	if (not playerr.playing):
		playerr.play()
	
func set_volume_recep(volume: float):
	playerr.volume_db = volume
	
func dopel_laugh():
	playerd.stream = load("res://Audios/Sons/Doppelganger-Audio-cue.ogg")
	if (not playerd.playing):
		playerd.play()

func janela_tocar(volume: float):
	playerj.stream = load("res://Audios/Sons/Rangido-Janela.ogg")
	playerj.volume_db = volume
	if (not playerj.playing):
		playerj.play()

func janela_stop():
	playerj.stop()
	
func janela_volume(volume: float):
	playerj.volume_db = volume
	
func tocar_radio():
	match Global.noite:
		2:
			player_radio.stream = load("res://Audios/Sons/Áudio Noite 2.ogg")
	player_radio.play()

func radio_volume(volume: float):
	player_radio.volume_db = volume
	
func radio_stop():
	player_radio.stop()
	
func tocar_ambient():
	player_ambi.stream = load("res://Audios/Sons/som_ambiente.ogg")
	player_ambi.play()
	
func stop_all():
	player_radio.stop()
	playerj.stop()
	playerr.stop()
	playerd.stop()
	player_ambi.stop()
