extends BaseInteractable

@export var dialogue_note: JSON

@export var main_camera: Camera3D
@export var target_camera: Camera3D

@export var handles: Array[MeshInstance3D] = []
@export var current_handle: int = 0

@export var setup_handles_rotation: Array[float] = [
	4.3,
	1.7,
	1.7,
	1.7
]

var _handles_materials: Array[ShaderMaterial] = []
var _enable_input: bool

func _ready() -> void:
	super._ready()
	
	var custom_options: Dictionary = {
		"Прочитать записку": read_note
	}
	custom_options.merge(_options)
	_options = custom_options
	
	for handle_idx in handles.size():
		var mat = handles[handle_idx].get_active_material(0)
		_handles_materials.append(mat)
		
		handles[handle_idx].rotation.z = setup_handles_rotation[handle_idx]
	return

func read_note() -> void:
	GameUi.hide_interact_instructions()
	GameUi.dialogue_ended.connect(on_dialogue_completed)
	GameUi.play_dialogue(dialogue_note.data)

func on_dialogue_completed() -> void:
	GameUi.dialogue_ended.disconnect(on_dialogue_completed)
	main_camera.current = true
	on_cancel()

func set_current_handle(idx: int) -> void:
	for handle_idx in handles.size():
		if handle_idx == idx:
			_handles_materials[handle_idx].set_shader_parameter("is_active", true)
		else:
			_handles_materials[handle_idx].set_shader_parameter("is_active", false)
	current_handle = idx

func on_interact() -> void:
	super.on_interact()
	
	target_camera.current = true
	_enable_input = true
	
	GameUi.show_interact_instructions("[AD] - Выбрать перключатель | [WS] - Переключить | [E] - Выйти")
	set_current_handle(0)
	return

func custom_input(event: InputEvent) -> void:
	if !_enable_input:
		return
		
	if event.is_action_pressed("interact"):
		main_camera.current = true
		_enable_input = false
		GameUi.hide_interact_instructions()
		call_deferred("on_cancel")
		
	var new_idx: int = current_handle
	
	if event.is_action_pressed("move_left"):
		new_idx = current_handle - 1
	if event.is_action_pressed("move_right"):
		new_idx = current_handle + 1
	
	var handle = handles[current_handle]
	#print(handle.rotation.z)
	if event.is_action_pressed("move_forward"):
		# bottom -> middle
		if handle.rotation.z >= 1.7 and handle.rotation.z < 3.5:
			_enable_input = false
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BOUNCE)
			tween.finished.connect(
				func(): _enable_input = true
			)
			tween.tween_property(handle, "rotation:z", 3.5, 1)
		# middle -> top
		if handle.rotation.z >= 3.5 and handle.rotation.z < 4.3:
			_enable_input = false
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BOUNCE)
			tween.finished.connect(
				func(): _enable_input = true
			)
			tween.tween_property(handle, "rotation:z", 4.3, 1)
		return
	if event.is_action_pressed("move_backward"):
		# top -> middle
		if handle.rotation.z >= 4.1:
			_enable_input = false
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BOUNCE)
			tween.finished.connect(
				func(): _enable_input = true
			)
			tween.tween_property(handle, "rotation:z", 3.5, 1)
		# middle -> bottom
		if handle.rotation.z >= 3.4 and handle.rotation.z < 4.1:
			_enable_input = false
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BOUNCE)
			tween.finished.connect(
				func(): _enable_input = true
			)
			tween.tween_property(handle, "rotation:z", 1.7, 1)
		return
	
	if current_handle != new_idx:
		set_current_handle(clampi(new_idx, 0, handles.size()))
	return
