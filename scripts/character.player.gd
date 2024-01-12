extends Character

# Called when the node enters the scene tree for the first time.
func _ready():
	var x_position = $Body.position[0]
	stem_loc = floor((x_position - 40) / GlobalVars.PIXEL_TO_CM)
	facing_right = true
	
	stats.display_name = 'Player'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
