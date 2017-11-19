extends "res://scripts/Projectile.gd"

var spawned_at = OS.get_unix_time()
var despawn_after = .6

func _process(delta):
	if (OS.get_unix_time() - spawned_at > despawn_after):
		queue_free()
		
func fly(delta):
	pass
	
func set_direction(new_direction):
	pass