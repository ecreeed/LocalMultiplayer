class_name Matching
extends Screen

@onready var code : Label = $Canvas/Margin/VBoxContainer/Code
@onready var options : VBoxContainer = $Canvas/Margin/VBoxContainer/Options

var current_options : Dictionary = {}


func _ready() -> void:
	code.text = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)


func _on_return_pressed() -> void:
	sys.close_server()
	change_scene("res://Menus/home.tscn")


func add_option(user_id : int, user_data : Dictionary) -> void:
	var new_opt : MPoption = preload("res://UI/MP_option/mp_option.tscn").instantiate()
	new_opt.init(user_data)
	new_opt.matching = self
	new_opt.peer_id = user_id
	current_options[user_id] = new_opt
	options.add_child(new_opt)


func remove_option(user_id: int) -> void:
	print("remove ", user_id)
	current_options[user_id].queue_free()


func selected_option(user_id : int) -> void:
	sys.start_battle(user_id)
