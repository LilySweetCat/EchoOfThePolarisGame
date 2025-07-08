extends Control

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	visible = false
	return

func _on_visibility_changed() -> void:
	var children = find_children("*", "", true, false)
	if visible:
		set_process(true)
		set_process_input(true)
		set_process_unhandled_input(true)
		
		for child in children:
			child.set_process(true)
			child.set_process_input(true)
			child.set_process_unhandled_input(true)
	else:
		set_process(false)
		set_process_input(false)
		set_process_unhandled_input(false)
		
		for child in children:
			child.set_process(false)
			child.set_process_input(false)
			child.set_process_unhandled_input(false)
	return
