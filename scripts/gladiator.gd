class_name Gladiator extends Node

var display_name := ''

var height := 0
var weight := 0

var strength := 1
var agility := 1
var attack := 1
var defense := 1
var vitality := 1
var charisma := 1
var stamina := 1
var magic := 1

var c_energy := 0 # Current energy
var m_energy := 0 # Max energy

var c_health := 0 # Current health
var m_health := 0 # Max health

var level := 1
var c_exp := 0 # Current experience
var n_exp := 100 # Needed experience for next level

# 0=Name, 1=min damage, 2=max damage, 3=type, 4=range,5=weight
# Types: Slash, Smash, Pierce, Range
# var weapon := ['Stem',1,3,'Smash',1,0]
var weapon = Weapon.new('Stem', Weapon.Weapon_Type.SMASH, 1, 3, 0, 1)

var armor := {
	'Stem Guard' : Armor.new('Stem', Armor.Armor_Type.NONE, 0, 0),
	'Upper Leaf Protector' : Armor.new('Leaf', Armor.Armor_Type.NONE, 0, 0),
	'Lower Leaf Protector' : Armor.new('Leaf', Armor.Armor_Type.NONE, 0, 0),
	'Mouth Guard' : Armor.new('Luscious Lips', Armor.Armor_Type.NONE, 0, 0),
	'Eye Protection' : Armor.new('Eyeballs', Armor.Armor_Type.NONE, 0, 0),
	'Shield' : Armor.new('None', Armor.Armor_Type.NONE, 0, 0)
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func calc_ac () -> int:
	# Calculates total armor class bonus
	var total_ac = 0
	for key in armor:
		total_ac += armor[key].armor_class
	return total_ac


func calc_stats ():
	# Calculate health and energy
	m_energy = stamina * 5 + 40
	m_health = vitality * 4 + 10


func res_energy (amount := 0, max := false) -> void:
	# Restores energy by either an amount or to maximum
	if max:
		c_energy = m_energy
	else:
		c_energy += amount
		if c_energy > m_energy: # Checks if the amount is greater than maximum
			c_energy = m_energy


func res_health (amount := 0, max := false) -> void:
	# Restores health by either amount or to maximum
	if max:
		c_health = m_health
	else:
		c_health += amount
		if c_health > m_health: # Verify health was not raised above max
			c_health = m_health

