extends Button

func _ready():
	pass

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_node("/root/Node2D/Network")._join_game()

