extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	var mousePosition = get_global_mouse_position()

	var globalPos = get_global_position()
	
	var lookingDirection = mousePosition - globalPos
	var angle = lookingDirection.angle()
	if(angle < - PI /2 || angle >  PI / 2):
		get_node("./base_idle_right").hide()
		get_node("./base_idle_left").show()
	else:
		get_node("./base_idle_right").show()
		get_node("./base_idle_left").hide()