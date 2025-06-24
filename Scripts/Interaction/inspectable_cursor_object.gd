extends StaticBody3D

@export var display_data : Array[String]

func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	return
	
func _on_mouse_entered() -> void:
	print("mouse entered")
	GameUi.animation_player.queue("show_search_cursor_data")
	return
	
func _on_mouse_exited() -> void:
	GameUi.animation_player.play_backwards("show_search_cursor_data")
	return
