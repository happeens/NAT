extends "res://scripts/Projectile.gd"

func _ready():
	speed = 1300
	
func on_collide(partner):
	if partner.get_name().begins_with("Player"):
		partner.get_hit(1)
		
	queue_free()