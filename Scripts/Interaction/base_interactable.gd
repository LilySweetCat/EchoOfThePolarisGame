class_name BaseInteractable
extends Area3D

@export var object_display_name : String
@export var action_name : String

# mesh с материалом который унаследован от interactable
@export var inspectable_mesh : MeshInstance3D

var _interactable_shader : ShaderMaterial
var _can_be_activated : bool

func _ready() -> void:
	_interactable_shader = inspectable_mesh.get_active_material(0)
	
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	return
	
func _on_body_entered(body: Node3D) -> bool:
	if body is not CharacterController or !_interactable_shader:
		return false
	
	_interactable_shader.set_shader_parameter("is_active", true)
	GameUi.show_interactive_object_name(object_display_name)
	
	_can_be_activated = true
	return true
	
func _on_body_exited(body: Node3D) -> bool:
	if body is not CharacterController or !_interactable_shader:
		return false
	
	_interactable_shader.set_shader_parameter("is_active", false)
	GameUi.hide_interactive_object_name()
	
	_can_be_activated = false
	return true

@export var player : CharacterController
	
func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("interact") || !_can_be_activated:
		return
	
	var options : Dictionary = {
		action_name : on_interact,
		"Отмена": on_cancel
	}
	
	player.can_move = false
	player.visible = false
	
	GameUi.show_actions(options, true)
	return
	
func on_cancel() -> void:
	print("cancel action")
	player.can_move = true
	player.visible = true
	return
	
func on_interact() -> void:
	print("proceed with action")
	GameUi.play_transition()
	
	_interactable_shader.set_shader_parameter("is_active", false)
	
	player.can_move = false
	player.visible = false
	return
