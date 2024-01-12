class_name Combat extends Node

var c_round : Round
var round_num := 0

var stem_to_stem := 0

signal game_end(loser : Character)
signal in_melee(is_true : bool)
signal end_turn(actor : Character, passive : Character)
signal action_result (text : String, is_ai : bool)
signal round_count (round : int)

func start_round (player : Character, ai : Character) -> void:
	round_num += 1
	round_count.emit(round_num)
	
	end_turn.emit(ai, player) # Sets health and energy correctly. Load bearing signal.
	
	c_round = Round.new(self, player, ai)
	c_round.start(player, ai)
	
	in_melee.emit(c_round.c_turn._player_in_melee())
	
	
func get_action (action : int) -> void:
	c_round.c_turn.do_action(action) # Do stuff.
	

# Called when the node enters the scene tree for the first time.
func _ready():
	in_melee.emit(false) # Preps the action buttons.  Sue me.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
