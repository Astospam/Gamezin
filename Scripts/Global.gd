extends Node

var tempo_decorrido: float = 1260.0
var pausado: bool = false
var local = "menu"
var prevlocal = ""
var noite = 1
var ultnoite = 1
var volume_radio = 0
var volume_recep = 0
var volume_janela = 0
var volume_elevador = 0
var pongon = false
var resetando = false
var engines_menu = false # Mantenha como 'false' para o estado inicial do menu
var projetos = true     # Mantenha como 'true' para o estado inicial do menu

const ter = ["terreo", "recepcao", "elevador_terreo"]
const pis1 = ["saida_incendio", "porta_incendio", "primeiro_piso", "elevador_1"]
const pis2 = ["gamelab", "computador", "segundo_piso", "corredor_janela", "janela", "elevador_2"]
const pis3 = ["terceiro_piso", "elevador_3"]

var monster_recep: int = 0
var monster_recep_prob = 0.4
var monster_recep_cd = 90.0
var monster_recep_time = 0.0
var monster_recep_answer = 7.5
var monster_recep_walk = 18.0
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
var dopel_stay_janela = 10.0
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


var elevador: int = 0
var elevador_prob = 0.6
var elevador_cd = 80.0
var elevador_time = 0.0
var elevador_answer = 7.0
var elevador_walk = 14.0
var elevador_local = "elevador"
var elevador_varia = 0
#

var invasor: int = 0
var invasor_prob = 0.5
var invasor_cd = 90.0
var invasor_time = 0.0
var invadindo = false
var play_inv = false

func _ready():
	randomize()
#

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
	
	if (local != "menu" and local != "morte"):
		#MONSTER RECEP
		if (local == monster_recep_local or (monster_recep == 2 and local == "recepcao")):
			print("morte")
			morrer(1)
		monster_reception_cdr()
		
		#DOPEL
		dopel_cdr()
		if ((local == "recepcao" and dopel == 1) or (local == "janela" and dopel == 2)):
			if (not SonsController.playerd.playing):
				SonsController.dopel_laugh()
				
		#JANELA
		janela_cdr()
		if (janela == 4 and (local == "gamelab" or local == "computador")):
			print("morte")
			morrer(3)
			
		#ELEVADOR
		elevador_cdr()
				
				
		#INVASOR
		invasor_cdr()
		
		if (resetando == true or invadindo == true):
			SonsController.radio_volume(-80.0)
		#TEMPO BÁSICO
		if pausado == false:
			if (dopel != 1):
				monster_recep_time += delta
			if (noite > 1):
				dopel_time += delta
			if (dopel != 2 and noite > 1 and janela_pause == false):
				janela_time += delta
			if (noite > 2):
				elevador_time += delta
				if (resetando == false):
					invasor_time += delta
			
			tempo_decorrido += delta
			if (tempo_decorrido >= 1440):
				tempo_decorrido = 0.0
			elif (tempo_decorrido < 1000) and (tempo_decorrido >= 300):
				acabar_noite()
		
func acabar_noite():
	pausado = true
	ultnoite += 1
	if (ultnoite >= 6):
		pausado = true
		SonsController.stop_all()
		local = "vitoria"
		get_tree().change_scene_to_file("res://Scenes/vitoria.tscn")
	else:
		call_deferred("comecar_noite", ultnoite)
	
func morrer(bixo: int):
	pausado = true
	SonsController.stop_all()
	local = "morte"
	# Não mude a cena aqui para a tela de morte, se a tela de morte for outro nó na mesma cena
	# Se a tela de morte for uma cena separada, manteríamos isso.
	# O ideal é que a tela de morte tenha um botão para chamar Global.reset_game()
	Transicao.jumpscare(bixo)

func comecar_noite(number_n: int):
	randomize()
	noite = number_n
	ultnoite = noite
	tempo_decorrido = 1260.0
	pausado = false
	SonsController.tocar_radio()
	SonsController.tocar_ambient()
	monster_reception_set()
	dopel_set()
	janela_set()
	elevador_set()
	invasor_set()
	SonsController.radio_volume(volume_radio)

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
	monster_recep_cd = 75.0 - (15*(noite-1))
	monster_recep_aberta = false
	noite_recep_prob()
		
func noite_recep_prob():
	if (noite!=1):
		monster_recep_prob = 0.6 + 0.1*(noite -2)
	else:
		monster_recep_prob = 0.5
		
		
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
				if monster_recep != 0 and janela != 0:
					dopel_set()
					print("ocupados")
				elif monster_recep != 0:
					dopel = 2
					print("dopel janela")
					SonsController.janela_tocar(volume_janela)
					await get_tree().create_timer(3.5).timeout
					SonsController.janela_stop()
				elif janela != 0:
					dopel = 1
					SonsController.tocar_recep(volume_recep)
					print("dopel porta")
				else:
					dopel = [1, 2].pick_random()
				if dopel == 1:
					SonsController.tocar_recep(volume_recep)
					print("dopel porta")
				else:
					SonsController.janela_tocar(volume_janela)
					await get_tree().create_timer(3.5).timeout
					SonsController.janela_stop()
					print("dopel janela")
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
	dopel_prob = 0.2 + 0.1*(noite -2)
	
	

#JANELA###########################################################################################
##################################################################################################
##################################################################################################
func janela_cdr():
	var recepla
	match janela:
		0: recepla = janela_cd
		1, 2, 3: recepla = janela_in
		_: recepla = 3000.0
	if (janela_time >= recepla):
		janela_time = 0.0
		janela_proba()

func janela_proba():
	match janela:
		0:
			if randf() < janela_prob:
				janela += 1
				janela_prob = 0.5 + 0.1*(noite -2)
				SonsController.janela_tocar(volume_janela)
				await get_tree().create_timer(3.5).timeout
				SonsController.janela_stop()
				print("janela bixo")
			else:
				janela_prob += 0.1
				janela_cd -= 20.0
				print("nothing j")
				print(janela_prob)

		1, 2, 3:
			if randf() < janela_prob:
				janela += 1
				janela_prob = 0.5 + 0.1*(noite -2)
				print("janela advance")
				print(janela)
			else:
				janela_prob += 0.1
				print("nothing j")
				
func janela_set():
	janela = 0
	janela_time = 0.0
	janela_cd = 50.0 - 7*(noite-2)
	janela_prob = 0.5 + 0.1*(noite -2)
	janela_in = 20.0 - 3*(noite-2)
	janela_liberar = 0.0
	

#ELEVADOR#######################################################################################
#############################################################################################
#############################################################################################

func elevador_cdr():
	var recepil
	match elevador:
		0: recepil = elevador_cd
		1, 2, 3, 4:
			if (elevador_local != "elevador"):
				recepil = elevador_walk
			else:
				recepil = elevador_answer
	if (elevador_time >= recepil):
		elevador_time = 0.0
		elevador_proba()
	
	
func elevador_proba():
	print(tempo_decorrido)
	match elevador:
		0:
			if randf() < elevador_prob:
				var places = [1, 2, 3, 4]
				elevador = places.pick_random()
				elevador_prob = 0.5 + 0.1*(noite -3)
				SonsController.tocar_elevador(volume_elevador)
				await get_tree().create_timer(7).timeout
				SonsController.elevador_stop()
				print("monstro elevador")
			else:
				elevador_prob += 0.1
				elevador_cd -= 20.0
				print("nothing e")

		1, 2, 3, 4:
			if randf() < 1 - elevador_prob:
				if (elevador_local != "elevador"):
					elevador = 0
					elevador_prob = 0.5 + 0.1*(noite -3)
					elevador_local = "elevador"
					print("elevador voltou")
				else:
					var locales = ["terceiro_piso", "saida_incendio", "corredor_janela"]
					var n = [1,2]
					elevador_local = locales.pick_random()
					elevador_varia = n.pick_random()
					print("elevador andou")
					print(elevador_local)
			else:
				if (elevador_local != "elevador"):
					var locales = ["terceiro_piso", "saida_incendio", "corredor_janela"]
					var n = [1,2]
					elevador_local = locales.pick_random()
					elevador_varia = n.pick_random()
					print("elevador andou")
					print(elevador_local)
				else:
					elevador_prob += 0.1
					print("elevador nothing")
		
func elevador_set():
	elevador_local = "elevador"
	elevador = 0
	elevador_time = 0.0
	elevador_prob = 0.5 + 0.1*(noite -3)
	elevador_cd = 80 - 20*(noite-3)
	elevador_local = "elevador"
		
		

#INVASOR###########################################################################################
##################################################################################################
##################################################################################################
func invasor_cdr():
	var receplou
	match invasor:
		0: receplou = invasor_cd
		_: receplou = 3000.0
	if (invasor_time >= receplou):
		invasor_time = 0.0
		invasor_proba()

func invasor_proba():
	match invasor:
		0:
			if randf() < invasor_prob:
				invasor += 1
				invadindo = true
				invasor_prob = 0.5 + 0.1*(noite -3)
				SonsController.invasor_tocar()
				print("invardindo")
			else:
				invasor_prob += 0.1
				invasor_cd -= 15.0
				print("nothing i")
				print(invasor_prob)

				
func invasor_set():
	invasor = 0
	invadindo = false
	invasor_time = 0.0
	invasor_cd = 90 - (15*(noite-3))
	invasor_prob = 0.5 + 0.1*(noite -3)

func reset_game():
	print("--- Executando Global.reset_game() ---")
	# Variáveis de Estado Geral do Jogo
	tempo_decorrido = 1260.0
	pausado = false
	local = "menu" # Garante que o estado seja 'menu'
	prevlocal = ""
	noite = 1
	ultnoite = 1 # Começa da noite 1
	volume_radio = 0
	volume_recep = 0
	volume_janela = 0
	volume_elevador = 0
	pongon = false
	resetando = false
	engines_menu = false # ESSENCIAL: Garante que o Enginer comece escondido
	projetos = true     # ESSENCIAL: Garante que o botão 'Projetos' esteja habilitado (mas invisível com Enginer)
	
	# Variáveis dos monstros (redefinindo para o estado inicial da primeira noite/jogo)
	monster_recep = 0
	monster_recep_prob = 0.4
	monster_recep_cd = 90.0
	monster_recep_time = 0.0
	monster_recep_answer = 7.5
	monster_recep_walk = 18.0
	monster_recep_local = "fora"
	monster_recep_aberta = false
	
	dopel = 0
	dopel_prob = 0.2
	dopel_cd = 100.0
	dopel_time = 0.0
	dopel_stay_door = 7.0
	dopel_stay_janela = 10.0
	
	janela = 0
	janela_prob = 0.5
	janela_cd = 60.0
	janela_in = 20.0
	janela_time = 0.0
	janela_liberar = 0.0
	janela_pause = false
	
	elevador = 0
	elevador_prob = 0.6
	elevador_cd = 80.0
	elevador_time = 0.0
	elevador_answer = 7.0
	elevador_walk = 14.0
	elevador_local = "elevador"
	elevador_varia = 0
	
	invasor = 0
	invasor_prob = 0.5
	invasor_cd = 90.0
	invasor_time = 0.0
	invadindo = false
	play_inv = false
	
	SonsController.stop_all() # Para todos os sons para começar "limpo"
	
	print("Variáveis globais redefinidas. Carregando cena de menu principal...")
	# Carrega a cena de menu principal, que agora deverá se comportar como se o jogo tivesse acabado de iniciar.
	get_tree().change_scene_to_file("res://Scenes/MENU.tscn")
