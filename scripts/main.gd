extends Node

var screen_size
var PIXEL_TO_CM = 5.93

var stem_to_stem = 0

enum Actor {Player, Enemy}
var Current_Actor : Actor

signal enemy_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	print('Viewport size: %s' % screen_size)
	
	$HUD/ActionLabel.text = 'Get closer and do something, you fuck!'
	$HUD/ActionLabel2.text = '%s thinks you\'re a little bitch!' % $Enemy.stats.display_name
	
	Current_Actor = Actor.Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var stat_format = '%d/%d'
	$HUD/PlayerHealth.text = stat_format % [$Player.stats.health[0], $Player.stats.health[1]]
	$HUD/PlayerEnergy.text = stat_format % [$Player.stats.energy[0], $Player.stats.energy[1]]
	
	$HUD/EnemyEnergy.text = stat_format % [$Enemy.stats.energy[0], $Enemy.stats.energy[1]]
	$HUD/EnemyHealth.text = stat_format % [$Enemy.stats.health[0], $Enemy.stats.health[1]]

	stem_to_stem = floor(($Enemy.stem - $Player.stem) / 5.93)
	GlobalVars.stem_to_stem = stem_to_stem
	$HUD/StemDistance.text = 'Stem-to-Stem Distance: %d cm' % stem_to_stem
	# Check if in weapon range
	# Change labels based on weapon range and current energy.
	if stem_to_stem > 40 + $Player.stats.weapon[4]:
		if $Player.stats.energy[0] <= 2:
			$HUD/TempLabel1.text = 'Rest'
			$HUD/TempLabel3.text = 'Rest'
		else:
			$HUD/TempLabel1.text = 'Walk Forward'
			$HUD/TempLabel3.text = 'Walk Backward'
		if $Player.stats.energy[0] <= 6:
			$HUD/TempLabel2.text = 'Rest'
			$HUD/TempLabel4.text = 'Rest'
		else:
			$HUD/TempLabel2.text = 'Jump Forward'
			$HUD/TempLabel4.text = 'Jump Backward'
		$HUD/TempLabel5.text = 'Taunt'
		if $Player.stats.energy[0] <= 8 + $Player.stats.weapon[5]:
			$HUD/TempLabel6.text = 'Rest'
		else:
			$HUD/TempLabel6.text = 'Charge'
	else:
		if $Player.stats.energy[0] <= 2:
			$HUD/TempLabel1.text = 'Rest'
		else:
			$HUD/TempLabel1.text = 'Walk Backward'
		if $Player.stats.energy[0] <= 6:
			$HUD/TempLabel2.text = 'Rest'
		else:
			$HUD/TempLabel2.text = 'Jump Backward'
		if $Player.stats.energy[0] <= 4 + $Player.stats.weapon[5]:
			$HUD/TempLabel4.text = 'Rest'
		else:
			$HUD/TempLabel4.text = 'Quick Attack'
		if $Player.stats.energy[0] <= 5 + $Player.stats.weapon[5]:
			$HUD/TempLabel5.text = 'Rest'
		else:
			$HUD/TempLabel5.text = 'Normal Attack'
		if $Player.stats.energy[0] <= 7 + $Player.stats.weapon[5]:
			$HUD/TempLabel6.text = 'Rest'
		else:
			$HUD/TempLabel6.text = 'Power Attack'
		$HUD/TempLabel3.text = 'Rest'


func _on_hud_act_1(): # Handles basic movement: backward and forward walk
	if stem_to_stem > 40 + $Player.stats.weapon[4]:
		$HUD/ActionLabel.text = 'Yeah!  Get in stabbin\' range!'
		$Combat.move_small($Player.stats, true)
	else:
		$HUD/ActionLabel.text = 'Don\'t run away, you coward!'
		$Combat.move_small($Player.stats, false)
	Current_Actor = Actor.Enemy
	enemy_turn.emit()

func _on_hud_act_2(): # Handles jumping.  Forward or backward.
	if stem_to_stem > 40 + $Player.stats.weapon[4]:
		$HUD/ActionLabel.text = 'Yeah!  Get in stabbin\' range!'
		$Combat.move_big($Player.stats, true)
	else:
		$HUD/ActionLabel.text = 'Don\'t run away, you coward!'
		$Combat.move_big($Player.stats, false)
	Current_Actor = Actor.Enemy
	enemy_turn.emit()
	
func _on_hud_act_3():
	if stem_to_stem > 40 + $Player.stats.weapon[4]:
		$HUD/ActionLabel.text = 'Don\'t run away, you coward!'
		$Combat.move_small($Player.stats, false)
	else:
		$Combat.rest($Player.stats)
	Current_Actor = Actor.Enemy
	enemy_turn.emit()

func _on_hud_act_4():
	if stem_to_stem > 40 + $Player.stats.weapon[4]:
		$HUD/ActionLabel.text = 'Don\'t run away, you coward!'
		$Combat.move_big($Player.stats, false)
	else:
		$Combat.attack($Player.stats, $Enemy.stats, $Combat.Attack_Type.Quick)
	Current_Actor = Actor.Enemy
	enemy_turn.emit()

func _on_hud_act_5():
	if stem_to_stem > 40 + $Player.stats.weapon[4]:
		$Combat.taunt($Player.stats, $Enemy.stats)
	else:
		$Combat.attack($Player.stats, $Enemy.stats, $Combat.Attack_Type.Normal)
	Current_Actor = Actor.Enemy
	enemy_turn.emit()

func _on_hud_act_6():
	if stem_to_stem > 40 + $Player.stats.weapon[4]:
		$Combat.attack($Player.stats, $Enemy.stats, $Combat.Attack_Type.Charge)
	else:
		$Combat.attack($Player.stats, $Enemy.stats, $Combat.Attack_Type.Power)
	Current_Actor = Actor.Enemy
	enemy_turn.emit()



func _on_combat_damage_dealt(amount) -> void:
	# Only changes display, statistics are modified in the emitting function
	match Current_Actor:
		Actor.Player:
			$HUD/ActionLabel.text = 'You dealt %d damage with your attack!' %amount
		Actor.Enemy:
			$HUD/ActionLabel2.text = '%s dealt %d damage to you with their attack!' %[$Enemy.stats.display_name, amount]

func _on_combat_energy_recovery(amount):
	pass # Replace with function body.


func _on_combat_energy_used(amount):
	pass # Replace with function body.


func _on_combat_forced_movement(pixels, cm, forward):
	pass # Replace with function body.


func _on_combat_health_recovery(amount):
	pass # Replace with function body.


func _on_combat_movement(pixels, cm, forward):
	match Current_Actor:
		Actor.Player:
			if forward:
				$Player.position[0] += pixels
				$Player.stem += pixels
			else:
				$Player.position[0] -= pixels
				$Player.stem -= pixels
		Actor.Enemy:
			if forward:
				$Enemy.position[0] -= pixels
				$Enemy.stem -= pixels
			else:
				$Enemy.position[0] += pixels
				$Enemy.stem += pixels


func _on_combat_recovery(energy, health):
	# Function controls statistics changes, this is just display
	var new_text = ''
	match Current_Actor:
		Actor.Player:
			new_text = 'You recovered %d energy and %d health.' % [energy, health]
			$HUD/ActionLabel.text = new_text
		Actor.Enemy:
			new_text = '%s recovered %d energy and %d health.' % [$Enemy.stats.display_name, energy, health]
			$HUD/ActionLabel2.text = new_text


func _on_combat_missed():
	var new_text = ''
	match Current_Actor:
		Actor.Player:
			new_text = 'You missed!  You suck!'
			$HUD/ActionLabel.text = new_text
		Actor.Enemy:
			new_text = '%s missed!  They suck!' % $Enemy.stats.display_name
			$HUD/ActionLabel2.text = new_text


func _on_enemy_turn():
	var roll = randi_range(1,6)
	match roll:
		1:
			if stem_to_stem > 40 + $Enemy.stats.weapon[4]:
				$HUD/ActionLabel2.text = 'They\'re getting in stabbin\' range!'
				$Combat.move_small($Enemy.stats, true)
			else:
				$HUD/ActionLabel2.text = 'They\'re running away! Coward!'
				$Combat.move_small($Enemy.stats, false)
		2:
			if stem_to_stem > 40 + $Enemy.stats.weapon[4]:
				$HUD/ActionLabel2.text = 'They\'re getting in stabbin\' range!'
				$Combat.move_big($Enemy.stats, true)
			else:
				$HUD/ActionLabel2.text = 'They\'re running away! Coward!'
				$Combat.move_big($Enemy.stats, false)
		3:
			if stem_to_stem > 40 + $Enemy.stats.weapon[4]:
				$HUD/ActionLabel2.text = 'They\'re running away! Coward!'
				$Combat.move_small($Enemy.stats, false)
			else:
				$Combat.rest($Enemy.stats)
		4:
			if stem_to_stem > 40 + $Enemy.stats.weapon[4]:
				$HUD/ActionLabel2.text = 'They\'re running away! Coward!'
				$Combat.move_big($Enemy.stats, false)
			else:
				$Combat.attack($Enemy.stats, $Player.stats, $Combat.Attack_Type.Quick)
		5:
			if stem_to_stem > 40 + $Enemy.stats.weapon[4]:
				$Combat.taunt($Enemy.stats, $Player.stats)
			else:
				$Combat.attack($Enemy.stats, $Player.stats, $Combat.Attack_Type.Normal)
		6:
			if stem_to_stem > 40 + $Enemy.stats.weapon[4]:
				$Combat.attack($Enemy.stats, $Player.stats, $Combat.Attack_Type.Charge)
			else:
				$Combat.attack($Enemy.stats, $Player.stats, $Combat.Attack_Type.Power)
	# Setting the current actor back to Player
	Current_Actor = Actor.Player


func _on_enemy_dead():
	$HUD/ActionLabel.text = '%s is dead!  You win!' %$Enemy.stats.display_name
	$HUD/ActionLabel2.hide()

func _on_player_dead():
	$HUD/ActionLabel.text = 'You died to %s! You suck!' %$Enemy.stats.display_name
	$HUD/ActionLabel2.hide()
