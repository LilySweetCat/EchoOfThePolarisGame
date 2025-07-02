extends BaseInteractable

@export var location_in: Node3D
@export var location_out: Node3D

var _currently_in: bool = false

func on_interact() -> void:
	super.on_interact()
	
	var dest = location_out.global_transform if _currently_in else location_in.global_transform
	
	player.global_transform = dest
	
	player.can_move = true
	player.visible = true
	
	_currently_in = !_currently_in
	return
