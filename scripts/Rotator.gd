extends Node2D

const pi = 3.14152

var max_ammo = 5
var ammo = max_ammo
var last_recharge = null
var recharge_duration = .8

func _ready():
	set_process(true)

func _process(delta):
	look_at( get_viewport().get_mouse_position() )
	rotate(+0.5)
	
	if (ammo < max_ammo && OS.get_unix_time() > last_recharge + recharge_duration):
		ammo += 1
		update_ammo_label()

#func _input(event):	
	#if (
	#	event.type == InputEvent.MOUSE_BUTTON &&
	#	event.button_index == BUTTON_LEFT &&
	#	event.pressed &&
	#	ammo > 0
	#):
	#	print("pew")
	#	shoot(event.pos - get_pos())

func shoot(where):
	ammo -= 1
	update_ammo_label()

func update_ammo_label():
	get_node("Label").set_text(ammo.to_string())