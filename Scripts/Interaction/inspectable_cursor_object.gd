extends StaticBody3D

@export var display_data : Array[String]

func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	return
	
func _on_mouse_entered() -> void:
	GameUi.show_cursor_data(display_data)
	return
	
func _on_mouse_exited() -> void:
	GameUi.animation_player.play("hide_search_cursor_data")
	return
