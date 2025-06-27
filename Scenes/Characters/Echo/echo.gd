extends BaseInteractable

@export var float_speed : float = 1.5
@export var float_amplitude : float = 0.2

@export var player_detection_radius = 2.0
@export var rotation_speed = 3.0

var _base_position : Vector3 = Vector3.ZERO
var _initial_rotation : Basis

func _ready():
	super._ready()
	_base_position = position
	_initial_rotation = global_transform.basis

func _process(delta: float):
	move()
	look_at_player_if_near(delta)
	return
	
func move() -> void:
	var offset = Vector3(
		sin(Time.get_ticks_msec() / 1000.0 * float_speed * 0.8),
		sin(Time.get_ticks_msec() / 1000.0 * float_speed),
		cos(Time.get_ticks_msec() / 1000.0 * float_speed * 1.2)
	) * float_amplitude

	position = _base_position + offset
	return
	
func look_at_player_if_near(delta: float) -> void:
	var distance = global_position.distance_to(player.global_position)
	var should_look = distance <= player_detection_radius

	var target_basis: Basis

	if should_look:
		# Поворачиваемся к игроку по Y (горизонтально)
		var to_player = player.global_position - global_position
		to_player.y = 0  # игнорируем наклон вверх/вниз
		to_player = to_player.normalized()
		target_basis = Basis().looking_at(to_player, Vector3.UP)
	else:
		# Возвращаемся к исходному взгляду
		target_basis = _initial_rotation

	# Плавно интерполируем поворот
	var current_quat = global_transform.basis.get_rotation_quaternion()
	var target_quat = target_basis.get_rotation_quaternion()
	var new_quat = current_quat.slerp(target_quat, rotation_speed * delta)
	global_transform.basis = Basis(new_quat)
	return
