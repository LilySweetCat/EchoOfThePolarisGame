extends Node3D

@export var rotation_speed: float = 15

var _target_rotation_x: float = 0.0
var _target_rotation_y: float = 0.0

func _process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if input_dir == Vector2.ZERO:
		input_dir = Vector2(0.1, 0.1)
	
	# Целевые углы вращения
	_target_rotation_x = input_dir.y * rotation_speed * delta
	_target_rotation_y = -input_dir.x * rotation_speed * delta
	
	# Плавный поворот Slerp
	var current_rot = rotation
	var target_rot = Vector3(_target_rotation_x, _target_rotation_y, 0) + current_rot
	
	rotation = current_rot.slerp(target_rot, 0.1)
	return
