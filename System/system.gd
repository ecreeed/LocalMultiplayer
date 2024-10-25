class_name System
extends Node2D

var current_scene : Screen = null
@export var starting_address : String
@onready var cover : ColorRect = $Canvas/Cover
@onready var MP : MP_mgr = $MP_mgr


func _ready() -> void:
	cover.modulate.a = 1
	cover.visible = true
	change_scene(starting_address)


func change_scene(new_add: String, fade_color: Color = Color.BLACK) -> void:
	var scene_check : Node = load(new_add).instantiate()
	if scene_check is Screen:
		var new_scene : Screen = scene_check
		var fader = get_tree().create_tween()
		cover.color = fade_color
		
		# Fade in the cover
		cover.visible = true
		fader.tween_property(cover,"modulate:a",1,0.5)
		fader.tween_property(cover,"modulate:a",0,0.5)
		await fader.step_finished
		
		# Exit the old scene and enter the new
		if current_scene:
			current_scene.exit()
			await current_scene.tree_exited
		new_scene.sys = self
		new_scene.enter()
		call_deferred("add_child", new_scene)
		current_scene = new_scene
		
		# Fade out the cover
		await fader.finished
		cover.visible = false
	else:
		print("ERROR: Address isn't of type: 'Screen'!")


func _on_mp_mgr_player_connected(peer_id: int, player_info: Dictionary) -> void:
	if current_scene is Matching:
		current_scene.add_option(peer_id,player_info)


func _on_mp_mgr_player_disconnected(peer_id: int) -> void:
	if current_scene is Matching:
		current_scene.remove_option(peer_id)


func host_lobby() -> void:
	MP.host_lobby()

func join_lobby(address: String) -> void:
	MP.join_lobby(address)

func close_server() -> void:
	MP.close_server()

func _on_mp_mgr_connection_failed() -> void:
	if current_scene is Home_Screen:
		current_scene.open_code()


func _on_mp_mgr_server_disconnected() -> void:
	if current_scene is Home_Screen:
		current_scene.open_code()


func start_battle(peer_id: int) -> void:
	change_scene("res://Game/game.tscn")
	MP.start_with(peer_id)


func _on_mp_mgr_load_game() -> void:
	change_scene("res://Game/game.tscn")
