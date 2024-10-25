class_name Home_Screen
extends Screen

@onready var code : TextEdit = $Canvas/Margin/Game/Join/Code


func _ready() -> void:
	code.editable = true

func _on_host_pressed() -> void:
	sys.host_lobby()
	change_scene("res://Menus/matching.tscn")


func _on_confirm_pressed() -> void:
	var address : String = code.text
	code.editable = false
	sys.join_lobby(address)


func _on_settings_pressed() -> void:
	change_scene("res://Menus/settings.tscn")

func open_code() -> void:
	code.editable = true
	code.text = ""
