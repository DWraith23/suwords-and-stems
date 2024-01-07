extends Node2D

var stats := Gladiator.new()

@export var speed = 200
var starting_stem
var stem = 0

signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	var x_position = $Body.position[0]
	stem = x_position - 40
	
	stats.calculate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stats.health[0] <= 0:
		hide()
		dead.emit()
