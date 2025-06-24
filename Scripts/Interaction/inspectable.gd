class_name Inspect
extends BaseInteractable

@export var current_camera : Camera3D
@export var inspect_camera : Camera3D

@export var player : CharacterController

var _prev_camera_position : Transform3D
	
func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("interact"):
		return
		
	_prev_camera_position = current_camera.global_transform
	
	GameUi.play_transition(
		func():
			current_camera.global_transform = inspect_camera.global_transform
			player.can_move = false
			player.visible = false
			return
	)
	
	GameUi.show_cursor()
	return
