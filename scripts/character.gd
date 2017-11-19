extends Node

const STARTING_HEALTH = 100
var health = 0

func _ready():
	health = STARTING_HEALTH

func get_hit(damage):
	health -= damage
	set_width(health)

func set_width(percent):
	var health_bar = get_node("health")
	health_bar.set_value(health)

func _process(delta):
	pass
