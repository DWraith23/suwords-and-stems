extends Node

var screen_size
var combat : Combat
var player : Character
var ai : Character

func game_over(loser : Character):
	loser.hide()
	$HUD.hide()
	if loser.is_ai:
		$HUD/ActionLabel2.hide()
		$HUD/ActionLabel.show()
		$HUD/ActionLabel.text = 'You win!'
	else:
		$HUD/ActionLabel.hide()
		$HUD/ActionLabel2.show()
		$HUD/ActionLabel2.text = 'You lose!  Faggot!'
		
	print('%s lost.' %loser.stats.display_name)
		
func start_game ():
	combat.start_round(player, ai)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	print('Viewport size: %s' % screen_size)
	
	combat = $Combat
	player = $Character/Player
	ai = $Character/Enemy
	
	$HUD/ActionLabel.text = 'Get closer and do something, you fuck!'
	$HUD/ActionLabel2.text = '%s thinks you\'re a little bitch!' % $Character/Enemy.stats.display_name

	player.stats.display_name = 'TesterBoy'
	
	print(player.stats.display_name)
	print('%d/%d' % [player.stats.c_health, player.stats.m_health])
	
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_combat_game_end(loser):
	game_over(loser)
