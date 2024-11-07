extends CharacterBody2D


var eDelta : float = 0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	$Label.text = name

func _physics_process(delta: float) -> void:
	eDelta = delta
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * 500
		move_and_slide()

@rpc("unreliable","any_peer","call_local")
func updatePos(id, pos) -> void:
	if !is_multiplayer_authority():
		if name == id:
			position = lerp(position, pos, eDelta * 15)


func _on_timer_timeout():
	if is_multiplayer_authority():
		rpc("updatePos", name, position)
