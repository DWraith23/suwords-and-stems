class_name Character extends Node2D

var stats := Gladiator.new()

var stem_loc := 0

var facing_right : bool
var is_ai : bool

func _init():
	stats.calc_stats()
	stats.res_energy(0,true)
	stats.res_health(0,true)

func movement (amount) -> void:
	# If the Character is facing to the left, movement is inverted.
	if facing_right:
		move_local_x(amount)
	else:
		move_local_x(-amount)
		

func stem_locator (amount) -> void:
	var change = floor(amount / GlobalVars.PIXEL_TO_CM)
	if facing_right:
		stem_loc += change
	else:
		stem_loc -= change

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
