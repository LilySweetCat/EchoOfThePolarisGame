@tool
class_name Positioner
extends Path3D

@export var viewport: int = 0
@export var curve_point: int = 0

@export var execute: bool:
	set(new_value):
		execute = new_value
		_on_execute_set()

# This will only be called when you create, delete, or paste a resource.
# You will not get an update when tweaking properties of it.
func _on_execute_set():
	print("starting to search editor camera")
	var editor_viewport = EditorInterface.get_editor_viewport_3d(viewport)
	var editor_camera : Camera3D = editor_viewport.get_camera_3d()
	
	self.curve.set_point_position(curve_point, editor_camera.position)
	return
