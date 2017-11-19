extends Button

func _ready():
	pass

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var ip = get_node("ip").get_text()
		get_node("/root/Node2D/Network")._join_game(ip)

