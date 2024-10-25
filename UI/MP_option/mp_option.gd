class_name MPoption
extends Button

@onready var dis_name : Label = $MarginContainer/Row/Data/Name
@onready var dis_rank : Label = $MarginContainer/Row/Data/Rank

var matching : Matching

var rank : int = 0
var username : String = "Placehold"
var peer_id : int = 0

func init(player_data: Dictionary) -> void:
	username = player_data["name"]
	rank = player_data["rank"]

func _ready() -> void:
	dis_name.text = username
	dis_rank.text = str(rank)


func _on_pressed() -> void:
	matching.selected_option(peer_id)
