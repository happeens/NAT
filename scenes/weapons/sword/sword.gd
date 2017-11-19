extends "res://scripts/Weapon.gd"

func _process(delta):
	look_at( get_viewport().get_mouse_position() )

func shoot(where):
	var theShot = shot.instance()
	
	get_tree().get_root().add_child(theShot)
	theShot.set_position( launcher.get_global_position() )
	theShot.look_at(where)