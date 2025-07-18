class_name BaseInteractable
extends Area3D

@export var object_display_name : String
@export var action_name : String = "Осмотреть"

@export var story_flag: String

# mesh с материалом который унаследован от interactable
@export var inspectable_mesh : MeshInstance3D
@export var player : CharacterController

var _interactable_shader : ShaderMaterial
var _can_be_activated : bool

var _options : Dictionary = {
		action_name : on_interact,
		"Отмена": on_cancel
	}

func _ready() -> void:
	_interactable_shader = inspectable_mesh.get_active_material(0)
	
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	return
	
func _on_body_entered(body: Node3D) -> bool:
	if body is not CharacterController or !_interactable_shader:
		return false
	
	print("Player entered")
	_interactable_shader.set_shader_parameter("is_active", true)
	
	GameUi.call_deferred("show_interactive_object_name", object_display_name)
	
	_can_be_activated = true
	return true
	
func _on_body_exited(body: Node3D) -> bool:
	if body is not CharacterController or !_interactable_shader:
		return false
	
	_interactable_shader.set_shader_parameter("is_active", false)
	GameUi.call_deferred("hide_interactive_object_name")
	
	_can_be_activated = false
	return true
	
func custom_input(event: InputEvent) -> void:
	return
	
func _input(event: InputEvent) -> void:
	custom_input(event)
	if event.is_action_pressed("interact") and _can_be_activated:
		_can_be_activated = false
		player.can_move = false
		#player.visible = false
		GameUi.call_deferred("show_actions", _options, true)
	#GameUi.show_actions(options, true)
	return
	
func on_cancel() -> void:
	print("cancel action")
	GameUi.play_transition()
	player.can_move = true
	player.visible = true
	_can_be_activated = true
	return
	
func on_interact() -> void:
	print("proceed with action")
	GameUi.play_transition()
	
	_interactable_shader.set_shader_parameter("is_active", false)
	
	player.can_move = false
	player.visible = false
	
	if story_flag:
		Storage.story_flags.append(story_flag)
	return
