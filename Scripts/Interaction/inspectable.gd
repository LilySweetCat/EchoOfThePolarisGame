extends BaseInteractable

@export var current_camera : Camera3D
@export var inspect_camera : Camera3D

var _prev_camera_position : Transform3D

func on_interact() -> void:
	super.on_interact()
	_prev_camera_position = current_camera.global_transform
	current_camera.global_transform = inspect_camera.global_transform
	GameUi.show_cursor()
	return
