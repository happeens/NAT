extends Node2D

onready var ammo_label = get_node("Label")

var max_ammo = 5
var ammo = max_ammo
var last_recharge = OS.get_unix_time()
var recharge_duration = .8

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	look_at( get_viewport().get_mouse_pos() )
	
	var current_time = OS.get_unix_time()
	
	if (ammo < max_ammo && current_time > last_recharge + recharge_duration):
		ammo += 1
		update_ammo_label()
		last_recharge = current_time

func _input(event):
	if (
		event.type == InputEvent.MOUSE_BUTTON &&
		event.button_index == BUTTON_LEFT &&
		event.pressed &&
		ammo > 0
	):
		shoot(event.pos - get_pos())

func shoot(where):
	ammo -= 1
	update_ammo_label()

func update_ammo_label():
	ammo_label.set_text( String(ammo) )
	ammo_label.update()