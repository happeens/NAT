extends Node2D

export var direction = Vector2(1, 0)
var speed = 1000

func _ready():
	set_process(true)
	
func set_direction(new_direction):
	direction = new_direction
	set_linear_velocity(direction * speed)
