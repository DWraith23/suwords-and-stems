class_name Gladiator extends Node2D

var display_name := 'CloverBot'
# 0=height, 1=weight
var body := [0,0]
# 0=Strength
# 1=Agility
# 2=Attack
# 3=Defense
# 4=Vitality
# 5=Charisma
# 6=Stamina
# 7=Magic
var statistics := [1,1,1,1,1,1,1,1]
# 0=current energy, 1=max energy
var energy := [45,45]
# 0=current health, 1=max health
var health := [14,14]

var armor_class := 0

var gold := 0

# 0=current, 1=neeeded
var experience := [0,100]

# 0=Name, 1=min damage, 2=max damage, 3=type, 4=range,5=weight
# Types: Slash, Smash, Pierce, Range
var weapon := ['Stem',1,3,'Smash',1,0]

var armor := {
	'Stem Guard' : ['Stem',0],
	'Upper Leaf Protector' : ['Leaf',0],
	'Lower Leaf Protector' : ['Leaf',0],
	'Mouth Guard' : ['Luscious Lips',0],
	'Eye Protection' : ['Eyeballs',0],
	'Shield' : ['None',0]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calculate ():
	# Calculate health and energy
	for i in range(2):
		energy[i] = 40 + (statistics[6] * 5)
		health[i] = 10 + (statistics[4] * 4)
	
	# Calculate armor class
	var ac_temp = 0
	for key in armor:
		ac_temp += armor[key][1]
	armor_class = ac_temp
	
	# If you're unarmed, the quality of your stem guard improves your stem damage (:
	if weapon[0] == 'Stem':
		weapon[1] += armor['Stem Guard'][1]
		weapon[2] += armor['Stem Guard'][1]

