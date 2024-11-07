class_name System
extends Node2D

var current_scene : Screen = null
@export var starting_address : String
@onready var cover : ColorRect = $Canvas/Cover

var is_host : bool = false
var join_ip : String

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
