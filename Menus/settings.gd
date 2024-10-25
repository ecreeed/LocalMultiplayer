class_name Settings
extends Screen

var player_settings : Dictionary = {}

@onready var name_entry : TextEdit = $Canvas/Margin/Contents/Options/Name/Entry


func enter() -> void:
	player_settings = JsonManager.read_json("res://JSONs/player_data.json")[0]


func _ready() -> void:
	name_entry.text = player_settings["name"]


func _on_return_pressed() -> void:
	change_scene("res://Menus/home.tscn")


func _on_confirm_pressed() -> void:
	var username : String = name_entry.text
	player_settings["name"] = username
	JsonManager.write_json("res://JSONs/player_data.json",[player_settings])
