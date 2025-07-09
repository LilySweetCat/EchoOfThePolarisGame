extends SpringArm3D

@export var target : Node3D

var yaw := 0.0
var pitch := 0.0
var sensitivity := 0.2
var base_rotation := Vector3.ZERO

#func _ready():
	#Находим направление к телу
	#look_at(target.global_position, Vector3.UP)
	#base_rotation = rotation_degrees
	#yaw = 0.0
	#pitch = 0.0

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity

		# Ограничения
		yaw = clamp(yaw, -30, 30)
		pitch = clamp(pitch, -15, 15)

func _physics_process(delta: float) -> void:
	look_at(target.global_position, Vector3.UP)
	base_rotation = rotation_degrees
	# Применяем отклонение от базовой ориентации
	rotation_degrees = base_rotation + Vector3(pitch, yaw, 0)
