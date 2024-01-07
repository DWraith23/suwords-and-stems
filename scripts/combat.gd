extends Node

enum Attack_Type {
	Quick,
	Normal,
	Power,
	Charge
}

const Attack_Vars = {
	Quick = {Energy_Change=-1, Accuracy_Change=2, Damage=0.67},
	Normal = {Energy_Change=0, Accuracy_Change=0, Damage=1.00},
	Power = {Energy_Change=2, Accuracy_Change=-2, Damage=1.20},
	Charge = {Energy_Change=3, Accuracy_Change=-2, Damage=0.80}
}

signal damage_dealt(amount : int)
signal energy_used(amount: int)
signal movement(pixels : int, cm : float, forward : bool)
signal forced_movement(pixels : int, cm : float, forward : bool)
signal health_recovery(amount: int)
signal energy_recovery(amount: int)
signal recovery(energy: int, health: int)
signal missed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func check_energy (gladiator : Gladiator, req : int) -> bool:
	if gladiator.energy[0] >= req:
		return true
	else:
		return false

func calc_energy (attacker : Gladiator, type : Attack_Type) -> int:
	# Weight of the weapon is a flat 1 : 1 modifier to energy requirement
	var weight = attacker.weapon[5]
	var type_mod = 0
	match type:
		Attack_Type.Quick:
			type_mod = Attack_Vars.Quick.Energy_Change
		Attack_Type.Normal:
			type_mod = Attack_Vars.Normal.Energy_Change
		Attack_Type.Power:
			type_mod = Attack_Vars.Power.Energy_Change
		Attack_Type.Charge:
			type_mod = Attack_Vars.Charge.Energy_Change
	# Base energy requirement for an attack is 5
	return 5 + weight + type_mod

func attack (attacker : Gladiator, defender : Gladiator, type : Attack_Type) -> void:
	# If you don't have enough energy to perform the attack, attack fails
	# If you do, lower your energy by the amount calculated
	# If you don't, rest
	var energy_cost = calc_energy(attacker, type)
	if !check_energy(attacker, energy_cost):
		rest(attacker)
		return
	else:
		attacker.energy[0] -= energy_cost
		energy_used.emit(energy_cost)
	# Handle unique actions for charges
	if type == Attack_Type.Charge:
		var cm_movement = attacker.statistics[1] * 5
		var pixel_movement = GlobalVars.CM_Convert(cm_movement)
		movement.emit(pixel_movement, cm_movement, true)
		if GlobalVars.stem_to_stem > 40 + attacker.weapon[4]:
			missed.emit()
			return
	# If you hit, deal damage.  If you miss, don't.
	if is_hit (attacker,defender,type):
		var damage = calc_damage(attacker, defender, type)
		defender.health[0] -= damage
		damage_dealt.emit(damage)
	else:
		return

func is_hit (attacker : Gladiator, defender : Gladiator, type : Attack_Type) -> bool:
	var acc_mod = 0
	var roll = randi_range(1,8)
	
	# Automatically miss if roll is minimum, automatically hit if maximum
	if roll == 1:
		missed.emit()
		return false
	elif roll == 8:
		return true
	# Set modifier to attack roll based on attack type
	match type:
		Attack_Type.Quick:
			acc_mod = Attack_Vars.Quick.Accuracy_Change
		Attack_Type.Normal:
			acc_mod = Attack_Vars.Normal.Accuracy_Change
		Attack_Type.Power:
			acc_mod = Attack_Vars.Power.Accuracy_Change
		Attack_Type.Charge:
			acc_mod = Attack_Vars.Charge.Accuracy_Change
	# Compare roll + acc_mod + attacker.attack to defender.defense + 4
	print('Rolled %d + %d (attack) + %d (mod)' % [roll, attacker.statistics[2], acc_mod])
	print('Total: %d' % (roll + attacker.statistics[2] + acc_mod))
	print('Target: %d' % (defender.statistics[3] + 5))
	if attacker.statistics[2] + roll + acc_mod > defender.statistics[3] + 4:
		return true
	else:
		missed.emit()
		return false
		
	
	
func calc_damage (attacker : Gladiator, defender : Gladiator, type : Attack_Type) -> int:
	# Roll damage based on attacker's minimum weapon damage to max weapon damage
	var roll = randi_range(attacker.weapon[1], attacker.weapon[2])
	# Add a percentage modifier based on type of attack
	var dam_mod = 0.00
	match type:
		Attack_Type.Quick:
			dam_mod = Attack_Vars.Quick.Damage
		Attack_Type.Normal:
			dam_mod = Attack_Vars.Normal.Damage
		Attack_Type.Power:
			dam_mod = Attack_Vars.Power.Damage
		Attack_Type.Charge:
			dam_mod = Attack_Vars.Charge.Damage
	# Sum up damage
	var damage = ((attacker.statistics[0]*2) + roll) * dam_mod
	damage = floor(damage)
	# Compare damage to enemy armor class
	# Always deal at least 1 damage
	if damage > defender.armor_class:
		return damage - defender.armor_class
	else:
		return 1
	
func taunt (user : Gladiator, target : Gladiator):
	pass #TODO
	
func move_small (user : Gladiator, forward : bool) -> void:
	# Uses 2 energy, check if available, rest if not
	if !check_energy(user, 2):
		rest(user)
		return
	else:
		user.energy[0] -= 2
		energy_used.emit(2)
	# Moves agility * 2 centimeters
	var cm_movement = user.statistics[1] * 2
	var pixel_movement = GlobalVars.CM_Convert(cm_movement)
	movement.emit(pixel_movement, cm_movement, forward)
	
func move_big (user : Gladiator, forward : bool) -> void:
		# Uses 6 energy, check if available, rest if not
	if !check_energy(user, 6):
		rest(user)
		return
	else:
		user.energy[0] -= 6
		energy_used.emit(6)
	# Moves agility * 5 centimeters.
	var cm_movement = user.statistics[1] * 5
	var pixel_movement = GlobalVars.CM_Convert(cm_movement)
	movement.emit(pixel_movement, cm_movement, forward)
	
func rest (user : Gladiator) -> void:
	# Recovers 20% of max energy (minimum 10)
	var e_recovery = floor(user.energy[1] / 5)
	if e_recovery < 10:
		e_recovery = 10
	# Recovers 10% of max health (minimum 1)
	var h_recovery = floor(user.health[1] / 10)
	if h_recovery < 1:
		h_recovery = 1
	# Check if recovery would raise above max
	if user.energy[0] + e_recovery > user.energy[1]:
		e_recovery = user.energy[1] - user.energy[0]
	if user.health[0] + h_recovery > user.health[1]:
		h_recovery = user.health[1] - user.health[0]
	# Apply the recovery
	user.energy[0] += e_recovery
	energy_recovery.emit(e_recovery)
	user.health[0] += h_recovery
	health_recovery.emit(h_recovery)
	recovery.emit(e_recovery, h_recovery)
	
	
func push (user : Gladiator, target : Gladiator) -> void:
	# Uses 5 energy, check if available, rest if not
	if !check_energy(user, 5):
		rest(user)
		return
	var weight_ratio = (user.body[1] / target.body[1]) + 1
	var distance_cm = floor(user.statistics[0] * weight_ratio)
	var distance_pixel = GlobalVars.CM_Convert(distance_cm)
	
	forced_movement.emit(distance_pixel, distance_cm, false)
	
func grapple (user : Gladiator, target : Gladiator):
	pass #TODO
	
func defend (user : Gladiator):
	pass #TODO

func cast (user : Gladiator, target : Gladiator, spell):
	pass #TODO
	

