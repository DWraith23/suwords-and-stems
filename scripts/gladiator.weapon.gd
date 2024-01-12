@icon('res://images/sword.png')
class_name Weapon extends Node

enum Weapon_Type {
	SLASH,
	SMASH,
	PIERCE
}

var display_name : String
var type : Weapon_Type
var min_damage : int
var max_damage : int
var weight : int
var range : int



func _init(display_name : String, type : Weapon_Type, min_damage : int,max_damage : int, weight : int, range: int):
	self.display_name = display_name
	self.type = type
	self.min_damage = min_damage
	self.max_damage = max_damage
	self.weight = weight
	self.range = range
	

func roll_damage () -> int:
	return randi_range(min_damage, max_damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
