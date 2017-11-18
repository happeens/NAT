extends Node2D

export var direction = Vector2(1, 0)
var speed = 1000

func _ready():
	set_process(true)

func _process(delta):
	fly(delta)
	
func fly(delta):
	translate(delta * speed * direction)
