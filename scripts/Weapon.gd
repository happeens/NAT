extends Node2D

onready var ammo_label = get_node("Label")

export(PackedScene) var shot

var max_ammo = 5
var ammo = max_ammo
var last_recharge = OS.get_unix_time()

const recharge_duration = .8

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	look_at( get_viewport().get_mouse_position() )
	rotate(.5) #AAAAAAAAH
	
	var current_time = OS.get_unix_time()
	
	if (ammo < max_ammo && current_time > last_recharge + recharge_duration):
		ammo += 1
		update_ammo_label()
		last_recharge = current_time

func _input(event):
	if (event.is_action("shoot") && ammo > 0):
		shoot(event.get_position() - get_position())

func shoot(where):
	var theShot = shot.instance()
	print(theShot.direction)
	
	get_tree().get_root().add_child(theShot)
	theShot.direction = where.normalized()
	theShot.set_position(get_global_position())
	#add_child(theShot)
	
	ammo -= 1
	update_ammo_label()

func update_ammo_label():
	ammo_label.set_text( String(ammo) )
