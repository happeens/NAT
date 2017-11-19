extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var animations = {
	"idle_right": "./base_idle_right",
	"idle_left": "./base_idle_left",
	"walk_right": "./base_walk_right",
	"walk_left": "./base_walk_left",
	"fly_right": "./base_fly_right",
	"fly_left": "./base_fly_left",
	"wall_right": "./base_wall_right",
	"wall_left": "./base_wall_left",
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func enableAnimation(animation):
	for anim in animations.values(): 
		var node = get_node(anim)
		if(node != null):
			node.hide()
	var active = get_node(animations[animation])
	active.show()
	

func _process(delta):

	var mousePosition = get_global_mouse_position()

	var globalPos = get_global_position()
	
	var lookingDirection = mousePosition - globalPos
	var angle = lookingDirection.angle()
	
	var character = get_parent()
	while character != null:
		# print(character.get_name())
		if(character.get_name() == "Character"):
			# print("found node!")
			break;
		else:
			character = character.get_parent()
	#	enableAnimation("walk_right")
	# walk right
	#if(character.get_target_speed() > 0):
	#	enableAnimation("walk_right")
	#elif(angle < - PI /2 || angle >  PI / 2):
	#	enableAnimation("idle_right")
	#else:
	#	enableAnimation("idle_left")