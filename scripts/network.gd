extends Node

const DEFAULT_PORT = 15234
const MAX_PEERS = 12

var players = {}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_joined")
	get_tree().connect("connected_to_server", self, "_player_connected")

func _player_joined(id):
	players[id] = id
	# print(str(players))

	if !get_tree().is_network_server():
		return
	for p in players:
		rpc_id(id, "spawn_character", p)

func _player_connected():
	spawn_character_for_all(get_tree().get_network_unique_id())

func spawn_character_for_all(id):
	rpc("spawn_character", id)

remote func spawn_character(id):
	var network_id = get_tree().get_network_unique_id()
	if network_id == id:
		spawn_player(load("res://scenes/Player.tscn"), id)
	else:
		spawn_player(load("res://scenes/character.tscn"), id)

func spawn_player(scene, id):
	var character = scene.instance()
	character.set_name(str(id))
	character.set_network_master(id)
	# print("spawning " + str(id))
	character.network_id = id
	get_node("/root/Node2D").add_child(character)

func _start_hosted_game():
	# load world
	# spawn player
	# master
	get_node("/root/Node2D/NetworkPanel").queue_free()
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)
	spawn_character(1)
	players[1] = 1

func _join_game():
	# load world
	# spawn player
	get_node("/root/Node2D/NetworkPanel").queue_free()
	var host = NetworkedMultiplayerENet.new()
	host.create_client("127.0.0.1", DEFAULT_PORT)
	get_tree().set_network_peer(host)

