extends Node

@onready var playerr = $BaterRecep
@onready var playerd = $Dopel
@onready var playerj = $JanelaSound
@onready var player_ambi = $Ambient
@onready var player_radio = $Radio
@onready var player_elevador = $ElevadorSound
@onready var player_invasor = $Diabo

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
		playerd.play(1.0)

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
		1:
			player_radio.stream = load("res://Audios/Sons/Locutor dia 1 completo.ogg")
		2:
			player_radio.stream = load("res://Audios/Sons/Áudio Noite 2.ogg")
		3:
			await get_tree().create_timer(0.5).timeout
			player_radio.stream = load("res://Audios/Sons/Locutora dia 3 completo.ogg")
		4:
			player_radio.stream = load("res://Audios/Sons/Áudio noite 4.ogg")
		5:
			player_radio.stream = load("res://Audios/Sons/Cultista completo.ogg")
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
	player_elevador.stop()
	player_invasor.stop()
	
func tocar_elevador(volume: float):
	player_elevador.stream = load("res://Audios/Sons/audio cue elevador.ogg")
	player_elevador.volume_db = volume
	if (not player_elevador.playing):
		player_elevador.play(2.0)
		
func elevador_volume(volume: float):
	player_elevador.volume_db = volume
	
func elevador_stop():
	player_elevador.stop()
	
func invasor_tocar():
	player_invasor.stream = load("res://Audios/Sons/Demonio-pc.ogg")
	if (not player_invasor.playing):
		print("playando")
		radio_volume(-80.0)
		player_invasor.stream.loop = true
		player_invasor.play()

func invasor_stop():
	print("stopando")
	player_invasor.stop()
	radio_volume(Global.volume_radio)

func pause_radio():
	if (player_radio.playing):
		player_radio.stream_paused = true

func despause_radio():
	player_radio.stream_paused = false
