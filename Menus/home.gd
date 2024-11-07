class_name Home_Screen
extends Screen


func _on_host_pressed():
	sys.is_host = true
	change_scene("res://Level/world.tscn")


func _on_join_pressed() -> void:
	sys.is_host = false
	sys.join_ip = $Canvas/TextEdit.text
	change_scene("res://Level/world.tscn")
