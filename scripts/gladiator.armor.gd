@icon('res://images/helmet.png')
class_name Armor extends Node

enum Armor_Type {
	NONE,
	LIGHT,
	MEDIUM,
	HEAVY
}

var display_name : String
var type : Armor_Type
var armor_class : int
var weight : int

func _init(display_name : String, type : Armor_Type, armor_class : int, weight : int):
	self.display_name = display_name
	self.type = type
	self.armor_class = armor_class
	self.weight = weight

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
