class_name Action extends Node

# Attack type indices:
# 0 : hit mod
# 1 : damage mod
# 2 : energy mod
static var attack_type = {
	'quick' : [2,-2,-1],
	'normal' : [0,0,0],
	'power' : [-2,3,2],
	'charge' : [-2,-1,-3] # Charge movement already costs 6 energy, goal is for a base of 8.
}

static func attack (att : Gladiator, def : Gladiator, type : String) -> int:
	# First, check if the attacker has the energy to do the attack.
	if !has_energy(att, get_energy_req(att.weapon, type)):
		return 0
	# Roll the attack roll.
	if is_hit(att, def, type):
		var damage = get_damage(att, type)
		var reduction = def.calc_ac()
		# Successful attacks always deal at least 1 damage
		if damage <= reduction:
			damage = 1
		else:
			damage -= reduction
		def.c_health -= damage # Lowers the defenders health. Death is handled later.
		return damage
	else:
		return 0


static func get_energy_req (weapon : Weapon, type : String) -> int:
	return weapon.weight + attack_type[type][2] + 5
	

static func is_hit (attacker : Gladiator, defender : Gladiator, type : String) -> bool:
	var roll = randi_range(0,7)
	if roll == 0: # Automatic miss
		return true
	elif roll == 7: # Automatic hit
		return false
	# If attack = defense, 50% chance of hitting.
	var target = defender.defense + 3
	# Apply the modifier for attack type and attacker attack stat
	var modifier = attacker.attack + attack_type[type][0]
	if roll + modifier >= target:
		return true
	else:
		return false
	

static func get_damage (attacker : Gladiator, type : String) -> int:
	var roll = randi_range(attacker.weapon.min_damage, attacker.weapon.max_damage)
	var modifier = attacker.strength * 2
	return roll + modifier + attack_type[type][1]
	

static func move (user : Character, multiplier : float, forward : bool, energy_req : int) -> int:
	# Check if you have the energy
	if !has_energy(user.stats, energy_req):
		return 0
	else:
		# Distance in pixels is agility * multiplier * pixel_to_cm conversion
		var distance = (user.stats.agility * multiplier) * GlobalVars.PIXEL_TO_CM
		# If forward is false, distance is reversed.
		if !forward:
			distance *= -1
		# Change the user's position[0] variable and stem location.
		user.movement(distance)
		user.stem_locator(distance)
		return distance

static func has_energy (user : Gladiator, req : int) -> bool:
	if user.c_energy >= req:
		return true
	else:
		return false


static func rest (user : Gladiator) -> Array:
	# Little bit of variance in your rest.  Maybe you had a muscle spasm, I don't make the rules.
	var energy = floor(user.m_energy / 5) + randi_range(-2,2)
	var health = floor(user.m_health / 10) + randi_range(-1,1)
	user.res_energy(energy)
	user.res_health(health)
	return [energy, health]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
