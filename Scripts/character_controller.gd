class_name CharacterController
extends CharacterBody3D

@export var speed : float = 3.0
@export var acceleration : float = 6.0
@export var rotation_speed : float = 6.0
@export var gravity : float = -9.8

@export var can_move : bool = true

var step_timer : float = 0.0
@export var step_interval : float = 0.4  # Задержка между шагами в секундах

@export var current_camera : Camera3D
var move_direction := Vector3.ZERO

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var footstep_player: AudioStreamPlayer3D = $FootstepPlayer

func _ready():
	current_camera = get_viewport().get_camera_3d()

func _physics_process(delta: float) -> void:
	if !can_move:
		return
	
	move_and_animate(delta)
	return
	
func move_and_animate(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	).normalized()

	if current_camera:
		var forward = current_camera.global_transform.basis.z
		var right = current_camera.global_transform.basis.x

		move_direction = (forward * input_vector.y + right * input_vector.x).normalized()

		var target_velocity = move_direction * speed
		velocity.x = lerp(velocity.x, target_velocity.x, acceleration * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, acceleration * delta)

		# Поворот персонажа к направлению движения
		if move_direction.length() > 0.1:
			var current_quat = global_transform.basis.get_rotation_quaternion()
			var target_basis = Basis.looking_at(move_direction, Vector3.UP)
			var target_quat = target_basis.get_rotation_quaternion()
			var new_quat = current_quat.slerp(target_quat, rotation_speed * delta)
			global_transform.basis = Basis(new_quat)  # применяем плавный поворот
			rotation.x = 0
			rotation.z = 0
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		
	# Определяем скорость по XZ (движение по плоскости)
	var horizontal_speed = Vector3(velocity.x, 0, velocity.z).length()
	# Масштабируем к диапазону BlendSpace (обычно 0.0–1.0)
	# Если walk — при скорости ~3.0, то делим на 3.0
	var blend_value = clamp(horizontal_speed / speed, 0.0, 1.0)
	# Устанавливаем значение BlendSpace
	anim_tree.set("parameters/movement/blend_position", blend_value)

	move_and_slide()
	return
