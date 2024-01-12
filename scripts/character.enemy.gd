extends Character

# Called when the node enters the scene tree for the first time.
func _ready():
	var x_position = $Body.position[0]
	stem_loc = floor((x_position + 40) / GlobalVars.PIXEL_TO_CM)
	facing_right = false
	
	is_ai = true
	
	stats.display_name = 'CloverBot'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
