class_name World
extends Screen

# Multiplayer variables
var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

func _ready() -> void:
	if sys.is_host:
		host_game()
	else:
		join_game()

func host_game() -> void:
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player(1)
	print(IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1))
	
func _add_player(id: int) -> void:
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)

func join_game() -> void:
	peer.create_client(sys.join_ip,135)
	multiplayer.multiplayer_peer = peer

func _on_exit_pressed() -> void:
	multiplayer.multiplayer_peer = null
	change_scene("res://Menus/home.tscn")
