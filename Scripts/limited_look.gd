extends SpringArm3D

@export var target : Node3D
@export var sensitivity := 0.1
@export var smooth_speed := 5.0 # чем больше — тем быстрее подстраивается

@export var h_max := 30
@export var v_max := 15

var yaw := 0.0
var pitch := 0.0
var base_rotation := Vector3.ZERO
var target_rotation := Vector3.ZERO

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity

		# Ограничения
		yaw = clampf(yaw, -h_max, h_max)
		pitch = clampf(pitch, -v_max, v_max)

func _physics_process(delta: float) -> void:
	look_at(target.global_position, Vector3.UP)
	base_rotation = rotation_degrees
	# Применяем отклонение от базовой ориентации
	#rotation_degrees = base_rotation + Vector3(pitch, yaw, 0)
	
	target_rotation = base_rotation + Vector3(pitch, yaw, 0)
	rotation_degrees = rotation_degrees.lerp(target_rotation, delta * smooth_speed)
