extends Area3D

@export var dialogue: JSON
@export var display_point_sprite: Sprite3D

var _tween: Tween

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	return
	
func on_mouse_entered() -> void:
	if _tween && !_tween.is_running():
		_tween.kill()
	
	print("on_mouse_entered")
	_tween = create_tween()
	_tween.tween_property(display_point_sprite, "modulate", Color.WHITE, 0.2)
	return
	
func on_mouse_exited() -> void:
	if _tween && !_tween.is_running():
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_property(display_point_sprite, "modulate", Color.TRANSPARENT, 0.2)
	return
