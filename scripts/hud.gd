extends CanvasLayer

signal act_1 (x : int)
signal act_2 (x : int)
signal act_3 (x : int)
signal act_4 (x : int)
signal act_5 (x : int)
signal act_6 (x : int)

var action_elements

func hide_actions ():
	for node in action_elements:
		node.hide()

func show_actions ():
	for node in action_elements:
		node.show()
	
func change_temp_label (text_in : String, slot : int) -> void:
	match slot:
		1: $TempLabel1.text = text_in
		2: $TempLabel2.text = text_in
		3: $TempLabel3.text = text_in
		4: $TempLabel4.text = text_in
		5: $TempLabel5.text = text_in
		6: $TempLabel6.text = text_in

func change_action_label (text_in : String, slot:int) -> void:
	match slot:
		1: $ActionLabel.text = text_in
		2: $ActionLabel2.text = text_in
		
func stem_measuring (distance : int) -> void:
	$StemDistance.text = 'Stem-to-Stem Distance is %d' % distance


func change_potions (actor : Character, target : Character):
	var stat_format = '%d/%d'
	if actor.is_ai:
		$PlayerHealth.text = stat_format % [target.stats.c_health, target.stats.m_health]
		$PlayerEnergy.text = stat_format % [target.stats.c_energy, target.stats.m_energy]
		$EnemyHealth.text = stat_format % [actor.stats.c_health, actor.stats.m_health]
		$EnemyEnergy.text = stat_format % [actor.stats.c_energy, actor.stats.m_energy]
	else:
		$PlayerHealth.text = stat_format % [actor.stats.c_health, actor.stats.m_health]
		$PlayerEnergy.text = stat_format % [actor.stats.c_energy, actor.stats.m_energy]
		$EnemyHealth.text = stat_format % [target.stats.c_health, target.stats.m_health]
		$EnemyEnergy.text = stat_format % [target.stats.c_energy, target.stats.m_energy]

# Called when the node enters the scene tree for the first time.
func _ready():
	action_elements = get_tree().get_nodes_in_group('actions')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_act_1():
	act_1.emit(1)

func _on_act_2():
	act_2.emit(2)

func _on_act_3():
	act_3.emit(3)

func _on_act_4():
	act_4.emit(4)

func _on_act_5():
	act_5.emit(5)

func _on_act_6():
	act_6.emit(6)


func _on_combat_end_turn(actor : Character, passive : Character):
	change_potions(actor, passive)
	stem_measuring(abs(actor.stem_loc - passive.stem_loc))
	if !actor.is_ai: # End of player turn, hide action buttons
		hide_actions()
	else: # End of AI turn, show action buttons
		show_actions()

func _on_combat_in_melee(is_true):
	print('Player in melee: %s,' %is_true)
	if is_true: # If the player is in melee
		print('I\'m in danger!')
		change_temp_label('Walk Backward', 1)
		change_temp_label('Jump Backward', 2)
		change_temp_label('Rest', 3)
		change_temp_label('Quick Attack', 4)
		change_temp_label('Normal Attack', 5)
		change_temp_label('Power Attack', 6)
	else: # If the player is at range
		print('No danger here, boss.')
		change_temp_label('Walk Forward', 1)
		change_temp_label('Jump Forward', 2)
		change_temp_label('Walk Backward', 3)
		change_temp_label('Jump Backward', 4)
		change_temp_label('Rest', 5)
		change_temp_label('Charge', 6)


func _on_combat_action_result(text, is_ai):
	if is_ai:
		change_action_label(text, 2)
	else:
		change_action_label(text, 1)


func _on_combat_round_count(round):
	$RoundLabel.text = 'Round: %d' % round
