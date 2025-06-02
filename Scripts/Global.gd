extends Node

var tempo_decorrido: float = 1260.0
var pausado: bool = false
var local = "computador"
var noite = 1
var ultnoite = 2

var volume_recep = 0

const ter = ["terreo", "recepcao", "elevador_terreo"]
const pis1 = ["saida_incendio", "porta_incendio", "primeiro_piso", "elevador_1"]
const pis2 = ["gamelab", "computador", "segundo_piso", "corredor_janela", "janela", "elevador_2"]
const pis3 = ["terceiro_piso", "elevador_3"]

var monster_recep: int = 0
var monster_recep_prob = 0.4
var monster_recep_cd = 90.0
var monster_recep_time = 0.0
var monster_recep_answer = 7.0
var monster_recep_walk = 14.0
var monster_recep_local = "fora"
var monster_recep_aberta: bool = false
#state1 - Na porta
#state2 - entrou
#state3 - saiu

var dopel:int = 0
var dopel_prob = 0.2
var dopel_cd = 100.0
var dopel_time = 0.0
var dopel_stay_door = 7.0
var dopel_stay_janela = 0.0
#state1 - Na porta
#state2 - Na janela


var janela:int = 0
var janela_prob = 0.5
var janela_cd = 60.0
var janela_in = 20.0
var janela_time = 0.0
var janela_liberar = 0.0
var janela_pause = false
#state1 - Está pouco
#state2 - Está
#state3 - Entrando
#state4 - Dentro
func salvar_jogo():
	var data = {
		"ultnoite": ultnoite
	}

	var file = FileAccess.open("user://save_game.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	
func carregar_jogo():
	if not FileAccess.file_exists("user://save_game.save"):
		return
	
	var file = FileAccess.open("user://save_game.save", FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse_string(content)
	if typeof(data) == TYPE_DICTIONARY:
		ultnoite = data.get("ultnoite", 0)

func _process(delta):

	#MONSTER RECEP
	if (local in ter):
		volume_recep = 0
	if (local in pis1):
		volume_recep = -7.0
	if (local in pis2):
		volume_recep = -14.0
	if (local in pis3):
		volume_recep = -21.0
			
	if (local == monster_recep_local or (monster_recep == 2 and local == "recepcao")):
		print("morte")
	monster_reception_cdr()
	
	#DOPEL
	dopel_cdr()
	if (not SonsController.dopel.playing):
		if (local == "recepcao" and dopel == 1):
			SonsController.dopel_laugh()
			
	#JANELA
	janela_cdr()
	if (janela == 4 and (local == "gamelab" or local == "computador")):
		print("morte")
			
	#TEMPO BÁSICO
	if pausado == false:
		if (dopel != 1):
			monster_recep_time += delta
		if (noite > 1):
			dopel_time += delta
		if (dopel != 2 and noite > 1 and janela_pause == false):
			janela_time += delta
		
		tempo_decorrido += delta
		if (tempo_decorrido >= 1440):
			tempo_decorrido = 0.0
		elif (tempo_decorrido < 1000) and (tempo_decorrido >= 300):
			acabar_noite()
		
func acabar_noite():
	pausado = true
	
func comecar_noite(number_n: int):
	randomize()
	noite = number_n
	tempo_decorrido = 1260.0
	pausado = false
	monster_reception_set()
	dopel_set()
	dopel_prob = 0.2 + 0.1*(noite -2)
	janela_set()
	janela_prob = 0.2 + 0.1*(noite -2)


#MONSTER RECEP###############################################################################
#############################################################################################
#############################################################################################
func monster_reception_cdr():
	var recep
	match monster_recep:
		0: recep = monster_recep_cd
		1: recep = monster_recep_answer
		2: recep = monster_recep_walk
	if (monster_recep_time >= recep):
		monster_recep_time = 0.0
		monster_reception_proba()
	
	
func monster_reception_proba():
	print(tempo_decorrido)
	match monster_recep:
		0:
			if randf() < monster_recep_prob:
				monster_recep += 1
				noite_recep_prob()
				if (monster_recep_aberta == false):
					SonsController.tocar_recep(volume_recep)
				print("monstro na porta")
			else:
				monster_recep_prob += 0.1
				monster_recep_cd -= 15.0
				print("nothing r")

		1:
			if randf() < monster_recep_prob or monster_recep_aberta == true:
				monster_recep += 1
				noite_recep_prob()
				monster_recep_local = "terreo"
				monster_recep_aberta = true
				print("monstro dentro")
			else:
				monster_recep_prob += 0.1
				SonsController.tocar_recep(volume_recep)
				print("nothing r")

		2:
			if randf() < 1.0 - monster_recep_prob:
				monster_reception_set()
				print("monstro saiu")
			else:
				monster_recep_prob -= 0.1
				var locais = ["terreo", "primeiro_andar", "segundo_andar"]
				monster_recep_local = locais.pick_random()
				print("andou" + monster_recep_local)
		
func monster_reception_set():
	monster_recep_local = "fora"
	monster_recep = 0
	monster_recep_time = 0.0
	monster_recep_cd = 90.0 - (15*(noite-1))
	noite_recep_prob()
		
func noite_recep_prob():
	if (noite!=1):
		monster_recep_prob = 0.5 + 0.1*(noite -2)
	else:
		monster_recep_prob = 0.4
		
		
#DOPEL#######################################################################################
#############################################################################################
#############################################################################################
func dopel_cdr():
	var recepel
	match dopel:
		0: recepel = dopel_cd
		1: recepel = dopel_stay_door
		2: recepel = dopel_stay_janela
	if (dopel_time >= recepel):
		dopel_time = 0.0
		dopel_proba()
		
		
func dopel_proba():
	print(tempo_decorrido)
	match dopel:
		0:
			if randf() < dopel_prob:
				match monster_recep and janela:
					!0 and !0:
						dopel_set()
						print("ocupados")
					!0 and 0:
						dopel = 2
						print("dopel janela")
					0 and !0:
						dopel = 1
						SonsController.tocar_recep(volume_recep)
						print("dopel porta")
					0 and 0:
						dopel = [1, 2].pick_random()
						if (dopel == 1):
							SonsController.tocar_recep(volume_recep)
						print("dopel n seik")
						print(dopel)
				dopel_prob = 0.2 + 0.1*(noite -2)
			else:
				dopel_prob += 0.1
				dopel_cd -= 10
				print("dopel nothing")
		1, 2:
			if randf() < 1 - dopel_prob:
				dopel_set()
				dopel_prob = 0.2 + 0.1*(noite -2)
				print("dopel saiu")
			else:
				dopel_prob -= 0.1
				print("dopel mantem")


func dopel_set():
	dopel = 0
	dopel_time = 0.0
	dopel_cd = 100.0 - (20*(noite-2))
	
	

#JANELA###########################################################################################
func janela_cdr():
	var recepla
	match janela:
		0: recepla = janela_cd
		1, 2, 3: recepla = janela_in
	if (janela >= recepla):
		janela_time = 0.0
		janela_proba()

func janela_proba():
	print(tempo_decorrido)
	match janela:
		0:
			if randf() < janela_prob:
				janela += 1
				janela_prob = 0.2 + 0.1*(noite -2)
				print("janela bixo")
			else:
				janela_prob += 0.1
				janela_cd -= 20.0
				print("nothing j")

		1, 2, 3:
			if randf() < janela_prob:
				janela += 1
				janela_prob = 0.2 + 0.1*(noite -2)
				print("janela advance")
				print(janela)
			else:
				janela_prob += 0.1
				print("nothing j")
				
func janela_set():
	janela = 0
	janela_time = 0.0
	janela_cd = 60.0 - (10*(noite-2))
	janela_prob = 0.2 + 0.1*(noite -2)
