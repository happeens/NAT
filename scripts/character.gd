extends KinematicBody2D

const STARTING_HEALTH = 100
var health = 0

var network_id = -1

var linear_vel = Vector2()

func is_local():
	return (network_id == get_tree().get_network_unique_id())

func is_single_player():
	return !get_tree().has_network_peer()
	
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

remote func process_position_update(id, pos, vel):
	if is_local():
		return

	var character = get_node("/root/Node2D/" + str(id))
	character.set_position(pos)
	character.linear_vel = vel

remote func process_animation_update(id, animation):
	var character
	if id > 0: 
		character = get_node("/root/Node2D/" + str(id))
	else:
		character = get_node(".")
	var natee = character.find_node("natee")
	natee.enableAnimation(animation)