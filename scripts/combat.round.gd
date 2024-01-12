class_name Round extends Node

var combat : Combat

var c_turn : Turn
var player : Character
var enemy : Character

signal game_end (c) # signals the game to end

class Turn:
	var actor : Character
	var target : Character
	var turn_phase : Phase
	var round : Round
	
	enum Phase {
		START,
		ACTION,
		PROCESS,
		CLEAN
	}
	
	func _init(r : Round, active : Character, passive : Character):
		actor = active
		target = passive
		round = r
		
	
	func do_action(slot : int):
		turn_phase = Phase.ACTION
		if _in_melee():
			_melee_actions(slot)
		else:
			_range_actions(slot)
		if !actor.is_ai:
			round.combat.in_melee.emit(_player_in_melee())
		_process_turn()
		
	
	func _process_turn() -> void:
		turn_phase = Phase.PROCESS
		# Process turn and emit any required signals.
		if target.stats.c_health <= 0:
			round.combat.game_end.emit(target) # Ends the game - goes to Main
			return
		round.combat.end_turn.emit(actor, target) # Cleans up HUD elements
		if !actor.is_ai: # This signal goes to the action labels to change them to the appropriate text
			round.next_turn(target, actor) # Move to the next turn with the AI as the active player.
		else:
			round.combat.start_round(target, actor) # Move to the next round of turns with the player active
		
		
	func _clean():
		pass #TODO
		
	func _in_melee () -> bool:
		var a_stem = actor.stem_loc # Actor stem position in "cm"
		var t_stem = target.stem_loc # Target stem position in "cm"
		var melee_range = 40 + actor.stats.weapon.range
		if abs(a_stem - t_stem) <= melee_range:
			return true
		else:
			return false
			
	func _player_in_melee () -> bool:
		var p_stem
		var e_stem
		var melee_range
		if !actor.is_ai:
			p_stem = actor.stem_loc # Actor stem position in "cm"
			e_stem = target.stem_loc # Target stem position in "cm"
			melee_range = 40 + actor.stats.weapon.range
		else: 
			e_stem = actor.stem_loc # Actor stem position in "cm"
			p_stem = target.stem_loc # Target stem position in "cm"
			melee_range = 40 + target.stats.weapon.range
		
		if abs(p_stem - e_stem) <= melee_range:
			return true
		else:
			return false
			
	func _melee_actions (slot : int) -> void:
		# Match slot selected to action.
		# This is returned if the combatants are within the actor's melee range
		var res # Result of the action
		var text = ''
		match slot:
			1:
				res = Action.move(actor, 2.0, false, 2)
				text = '%s moved backward.  Coward!' % [actor.stats.display_name, res]
			2:
				res = Action.move(actor, 5.0, false, 5)
				text = '%s moved backward.  Coward!' % [actor.stats.display_name, res]
			3:
				res = Action.rest(actor.stats)
				text = '%s recovered %d energy and %d health.' % [actor.stats.display_name, res[0], res[1]]
			4:
				res = Action.attack(actor.stats, target.stats, 'quick')
				text = '%s did %d damage with their quick attack!' % [actor.stats.display_name, res]
			5:
				res = Action.attack(actor.stats, target.stats, 'normal')
				text = '%s did %d damage with their normal attack!' % [actor.stats.display_name, res]
			6:
				res = Action.attack(actor.stats, target.stats, 'power')
				text = '%s did %d damage with their power attack!' % [actor.stats.display_name, res]
		broadcast_action(text, actor.is_ai)


	func _range_actions (slot : int) -> void:
		# Match slot selected to action.
		# This is returned if the combatants are outside of the actor's melee range
		var res # Result of the action
		var text = ''
		match slot:
			1:
				res = Action.move(actor, 2.0, true, 2)
				text = '%s moved forward.  Get to stabbing!' % [actor.stats.display_name]
			2:
				res = Action.move(actor, 5.0, true, 5)
				text = '%s moved forward.  Get to stabbing!' % [actor.stats.display_name]
			3:
				res = Action.move(actor, 2.0, false, 2)
				text = '%s moved backward.  Coward!' % [actor.stats.display_name]
			4:
				res = Action.move(actor, 5.0, false, 5)
				text = '%s moved backward.  Coward!' % [actor.stats.display_name]
			5:
				res = Action.rest(actor.stats)
				text = '%s recovered %d energy and %d health.' % [actor.stats.display_name, res[0], res[1]]
			6:
				res = Action.move(actor,5.0,true,6)
				text = '%s moved forward, but stumbled their charge.' % actor.stats.display_name
				if _in_melee(): # Attack only works if the movement gets you to melee range
					res = Action.attack(actor.stats, target.stats, 'charge')
					text = '%s did %d damage with their charge attack!' % [actor.stats.display_name, res]
		broadcast_action(text, actor.is_ai)


	func broadcast_action (text : String, is_ai : bool) -> void:
		round.combat.action_result.emit(text, is_ai)


func start (active : Character, passive : Character):
	print('Round started.')
	c_turn = Turn.new(self, active, passive)
	c_turn.turn_phase = Turn.Phase.START
	print('%s is up.' % c_turn.actor.stats.display_name)
	# If not the player, my amazing and sophisticated AI is performed.
	if active.is_ai:
		var roll = randi_range(1,6)
		c_turn.do_action(roll)
		

func next_turn (active : Character, passive : Character) -> void:
	print('Next turn.  %s (%s) is up.' % [active.stats.display_name, active.is_ai])
	c_turn = Turn.new(self, active, passive)
	c_turn.turn_phase = Turn.Phase.START
	if active.is_ai:
		var roll = randi_range(1,6)
		c_turn.do_action(roll)

func _init(c : Combat, p : Character, e : Character):
	player = p
	enemy = e
	combat = c

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
