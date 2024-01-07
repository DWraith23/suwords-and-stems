extends Node

var Skumm_Sucks := true

var PIXEL_TO_CM = 5.93 # The ratio of pixels to each centimeter, roughly.
var NOSE_TO_NOSE = 40 # Stem-to-Stem value where the clovers are touching

func CM_Convert (amount : int, invert=false) -> float:
	# This function is entirely unnecessary as a global function, but funni
	if invert:
		return amount / 5.93
	else:
		return amount * 5.93
		
# Used entirely for charging logic right now, because I'm a fucking moron
var stem_to_stem = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
