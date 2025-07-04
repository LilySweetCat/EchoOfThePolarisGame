extends BaseInteractable

@export var pickable_item: Node3D
@export var look_item_location: Node3D

func on_interact() -> void:
	super.on_interact()
	
	pickable_item.scale = Vector3.ZERO
	var tween = create_tween()
	return
