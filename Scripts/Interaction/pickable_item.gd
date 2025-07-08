extends BaseInteractable

@export var inventory_item: InventoryItem
@export var dialogue_when_pick: JSON

@export var pickable_item: Node3D
@export var look_item_location: Node3D
@export var main_camera: Camera3D

@export var DoF_distance: float = 2.0
@export var rotation_speed: float = 15

var _target_rotation_x: float = 0.0
var _target_rotation_y: float = 0.0

var _enable_input: bool
var _initial_rotation_differs: bool

var _viewing: bool

func _input(event: InputEvent) -> void:
	super._input(event)
	
	if !event.is_action_pressed("interact") || !_viewing:
		return
		
	_viewing = false
	
	Storage.inventory.append(inventory_item)
	GameUi.call_deferred("play_dialogue", dialogue_when_pick.data)
	GameUi.dialogue_ended.connect(pick_item_dialogue_ended)
	return

func pick_item_dialogue_ended() -> void:
	GameUi.dialogue_ended.disconnect(pick_item_dialogue_ended)
	
	GameUi.call_deferred("hide_interact_instructions")
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(pickable_item, "scale", Vector3.ZERO, 0.2)
	tween.tween_property(main_camera.attributes, "dof_blur_far_distance", 10, 0.5)
	
	tween.finished.connect(
		func():
			super.on_cancel()
			pickable_item.queue_free()
			self.queue_free()
	)
	return

func on_interact() -> void:
	GameUi.play_transition()
	
	_interactable_shader.set_shader_parameter("is_active", false)
	
	player.can_move = false
	
	pickable_item.scale = Vector3.ZERO
	pickable_item.global_position = look_item_location.global_position
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(pickable_item, "scale", Vector3.ONE, 1.0)
	tween.tween_property(main_camera.attributes, "dof_blur_far_distance", DoF_distance, 0.5)
	tween.finished.connect(
		func():
			_enable_input = true
			_viewing = true
	)
	
	GameUi.call_deferred("show_interact_instructions")
	
	return

func _physics_process(delta: float) -> void:
	if !_enable_input:
		return
		
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if input_dir == Vector2.ZERO:
		input_dir = Vector2(0.1, 0.1)
	
	# Целевые углы вращения
	_target_rotation_x = input_dir.y * rotation_speed * delta
	_target_rotation_y = -input_dir.x * rotation_speed * delta
	
	# Плавный поворот Slerp
	var current_rot = pickable_item.rotation
	var target_rot = Vector3(_target_rotation_x, _target_rotation_y, 0) + current_rot
	
	pickable_item.rotation = current_rot.slerp(target_rot, 0.1)
	return
