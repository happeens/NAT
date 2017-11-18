extends Node

const DEFAULT_PORT = 15234
const MAX_PEERS = 12

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected(id):
	print(id + " connected")

func _start_hosted_game():
	# load world
	# spawn player
	# master
	get_node("/root/Node2D/NetworkPanel").queue_free()
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)

	var player = load("res://scenes/Player.tscn").instance()
	get_node("/root/Node2D").add_child(player)
