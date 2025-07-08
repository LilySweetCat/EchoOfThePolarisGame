extends BaseInteractable

@export var mind_palace : PackedScene

func _update_shader_param(value: float) -> void:
	_interactable_shader.set_shader_parameter("emission_power", value)
	return

func on_interact() -> void:
	GameUi.play_transition()
	
	player.can_move = false
	player.visible = true
	
	_interactable_shader.set_shader_parameter("is_active", false)
	_interactable_shader.set_shader_parameter("highlight_as_base_color", true)
	
	var tween = create_tween()
	tween.tween_method(_update_shader_param, 1.0, 4.0, 3)
	tween.finished.connect(
		func():
			var game_ui_tween = GameUi.blackout(Color.RED, 3)
			game_ui_tween.finished.connect(
				func():
					get_tree().change_scene_to_packed(mind_palace)	
			)
	)
	return
