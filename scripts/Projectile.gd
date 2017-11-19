extends Node2D

export var direction = Vector2(1, 0)
var speed = 1000

func _ready():
	set_process(true)
	
func _process(delta):
	for body in get_colliding_bodies():
		on_collide(body)
	
func set_direction(new_direction):
	direction = new_direction
	set_linear_velocity(direction * speed)

func on_collide(partner):
	pass