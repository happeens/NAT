extends "res://scripts/Weapon.gd"

func _ready():
	max_ammo = 5
	ammo = max_ammo
	recharge_duration = 1.5
	
func on_ammo_empty():
	player.set_weapon(player.default_weapon)