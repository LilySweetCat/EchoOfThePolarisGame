class_name BaseInteractable
extends Area3D

@export var display_name : String

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
	GameUi.show_interactive_object_name(display_name)
	
	_can_be_activated = true
	return true
	
func _on_body_exited(body: Node3D) -> bool:
	if body is not CharacterController or !_interactable_shader:
		return false
	
	_interactable_shader.set_shader_parameter("is_active", false)
	GameUi.hide_interactive_object_name()
	
	_can_be_activated = false
	return true
