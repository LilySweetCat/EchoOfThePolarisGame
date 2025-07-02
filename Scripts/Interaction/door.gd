extends BaseInteractable

@export var use_only_in: bool
@export var location_in: Node3D
@export var location_out: Node3D

var _currently_in: bool = false

func on_interact() -> void:
	super.on_interact()
	
	if !use_only_in:
		var dest = location_out.global_transform if _currently_in else location_in.global_transform
		player.global_transform = dest
		_currently_in = !_currently_in
	else:
		player.global_transform = location_in.global_transform
	
	player.can_move = true
	player.visible = true
	
	return
