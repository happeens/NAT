extends Node2D

export(PackedScene) var shot

var max_ammo = 5
var ammo = max_ammo
var last_recharge = OS.get_unix_time()

var recharge_duration = .8

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	look_at( get_global_mouse_position() )
	
	var current_time = OS.get_unix_time()
	
	if (ammo < max_ammo && current_time > last_recharge + recharge_duration):
		ammo += 1
		update_ammo_label()
		last_recharge = current_time

func _input(event):
	if (event.is_action_pressed("shoot") and ammo > 0):
		shoot(event.get_global_position() - get_global_position())
		#rpc_unreliable("shoot", event.get_position() - get_position())

remote func shoot(where):
	var theShot = shot.instance()
	
	get_tree().get_root().add_child(theShot)
	theShot.set_position(get_global_position())
	theShot.set_direction(where.normalized())
	theShot.look_at(where)
	
	ammo -= 1
	update_ammo_label()

func update_ammo_label():
	#ammo_label.set_text( String(ammo) )
	pass
