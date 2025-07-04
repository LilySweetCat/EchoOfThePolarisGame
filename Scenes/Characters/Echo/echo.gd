class_name EchoController
extends BaseInteractable

@export var dialogue : JSON

@export var float_speed : float = 1.5
@export var float_amplitude : float = 0.2

@export var player_detection_radius = 2.0
@export var rotation_speed = 3.0

@export var pause: bool
@export var particle_systems: Array[GPUParticles3D]

var _base_position : Vector3 = Vector3.ZERO
var _initial_rotation : Basis

#dialogue
var actions : Dictionary = {}

func _ready():
	super._ready()
	_base_position = position
	_initial_rotation = global_transform.basis

func _process(delta: float):
	if pause:
		return
	
	move()
	look_at_player_if_near(delta)
	return
	

func on_interact() -> void:
	super.on_interact()
	actions = {}
	
	#print(dialogue.data[0]["text"])
	#GameUi.play_dialogue(dialogue.data)
	GameUi.dialogue_ended.connect(on_dialogue_ended)
	
	for option in dialogue.data:
		var option_text = option["option"]
		var option_responses = option["responses"]
		
		#print(option_responses)
		actions[option_text] = func(): GameUi.call_deferred("play_dialogue", option_responses)
	
	actions["Отойти"] = on_cancel
	GameUi.call_deferred("show_actions", actions, true)
	
	return

func on_cancel() -> void:
	GameUi.dialogue_ended.disconnect(on_dialogue_ended)
	super.on_cancel()
	return
	
func on_dialogue_ended() -> void:
	GameUi.call_deferred("show_actions", actions, true)
	return

	
func update_base_position(new_position: Vector3) -> void:
	_base_position = new_position
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
	#var should_look = distance <= player_detection_radius

	var target_basis: Basis

	#if should_look:
		# Поворачиваемся к игроку по Y (горизонтально)
	var to_player = player.global_position - global_position
	to_player.y = 0  # игнорируем наклон вверх/вниз
	to_player = to_player.normalized()
	target_basis = Basis().looking_at(to_player, Vector3.UP)
	#else:
	#	# Возвращаемся к исходному взгляду
	#	target_basis = _initial_rotation

	# Плавно интерполируем поворот
	var current_quat = global_transform.basis.get_rotation_quaternion()
	var target_quat = target_basis.get_rotation_quaternion()
	var new_quat = current_quat.slerp(target_quat, rotation_speed * delta)
	global_transform.basis = Basis(new_quat)
	return
