class_name MP_mgr
extends Node

signal player_connected(peer_id : int, player_info : Dictionary)
signal player_disconnected(peer_id : int)
signal server_disconnected
signal connection_failed
signal load_game


var players : Dictionary = {}

# Setup
func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connection_failed.connect(_on_connection_fail)

# When the player hosts a game as server, returns address
func host_lobby() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	
	var player_info : Dictionary = JsonManager.read_json("res://JSONs/player_data.json")[0]
	players[1] = player_info
	player_connected.emit(1,player_info)

# When the player joins a game as client
func join_lobby(address: String) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address,135)
	multiplayer.multiplayer_peer = peer

# When a peer connects, sends their player data more than ID
func _on_player_connected(id) -> void:
	var player_info : Dictionary = JsonManager.read_json("res://JSONs/player_data.json")[0]
	_register_player.rpc_id(id,player_info)

@rpc("any_peer","reliable")
func _register_player(new_player_info) -> void:
	var new_player_id : int = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

# When the player disconnects, remove them from pool
func _on_player_disconnected(id) -> void:
	players.erase(id)
	player_disconnected.emit(id)

# When the server disconnects
func _on_server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

# When the client fails to connect to server
func _on_connection_fail() -> void:
	multiplayer.multiplayer_peer = null
	connection_failed.emit()

# Called for client when they're kicked
@rpc("any_peer")
func kicked() -> void:
	multiplayer.multiplayer_peer = null

# Close the server and kick all clients
func close_server() -> void:
	kicked.rpc()
	multiplayer.multiplayer_peer = null

# Prevents new players from joining the server
func start_with(target_id: int) -> void:
	multiplayer.multiplayer_peer.refuse_new_connections = false
	for peer in multiplayer.get_peers():
		if peer not in [1, target_id]:
			kicked.rpc_id(peer)
	load_pass.rpc_id(target_id)

# Loads the game for the targeted player
@rpc("any_peer")
func load_pass() -> void:
	load_game.emit()
