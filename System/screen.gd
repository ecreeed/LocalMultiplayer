class_name Screen
extends Node2D

var sys : System


func exit() -> void:
	queue_free()


func enter() -> void:
	pass


func change_scene(new_address : String, clr: Color = Color.BLACK) -> void:
	if sys:
		sys.change_scene(new_address,clr)
	else:
		print("ERROR: Sys not linked to Screen!")
