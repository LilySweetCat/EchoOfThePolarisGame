extends BaseInteractable

@export var dialogue: JSON

@export var main_camera: Camera3D
@export var target_camera: Camera3D

@export var tuner: Node3D
@export var freq: Node3D

@export var current_freq: float = 50
@export var target_freq: float = 51.58
@export var delta_freq: float = 0.2

@export var clamp_rot: float = 90
@export var clamp_move: float = 0.054

@export var change_freq_rot_speed: float = 0.8
@export var change_freq_move_speed: float = 0.0205

var _focused: bool

func on_interact() -> void:
	super.on_interact()
	
	GameUi.show_interact_instructions("[AD] - изменить частоту | [E] - выйти")
	target_camera.current = true
	_focused = true

func _physics_process(delta: float) -> void:
	if not _focused:
		return
		
	var input : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if input.x == 0:
		return
		
	var diff_x = input.x * change_freq_rot_speed * delta
	var new_rot = tuner.rotation + Vector3(diff_x, 0,0)
	tuner.rotation = new_rot
	
	var move_diff_x = input.x * change_freq_move_speed * delta
	var clamped_translate_diff = clampf(move_diff_x, -clamp_move, clamp_move)
	
	if freq.position.z + clamped_translate_diff >= clamp_move or freq.position.z + clamped_translate_diff <= -clamp_move:
		return
	freq.translate(Vector3(0, 0, clamped_translate_diff))
	current_freq += diff_x
	
	if current_freq >= target_freq - delta_freq and current_freq <= target_freq + delta_freq:
		_focused = false
		GameUi.hide_interact_instructions()
		GameUi.dialogue_ended.connect(on_dialogue_completed)
		GameUi.play_dialogue(dialogue.data)

func on_dialogue_completed() -> void:
	GameUi.dialogue_ended.disconnect(on_dialogue_completed)
	main_camera.current = true
	on_cancel()
