extends RayCast3D

@export var progress_speed: float = 0.1
@export var progress: float = 0.0

var _in_dialogue: bool
var _cursor_material: ShaderMaterial

func _ready() -> void:
	_cursor_material = GameUi.cursor.material

func _physics_process(delta: float) -> void:
	if not is_colliding():
		progress = 0
		_cursor_material.set_shader_parameter("fill_amount", progress)
		return
		
	var collider = get_collider()
	if collider is not CluePoint:
		progress = 0
		_cursor_material.set_shader_parameter("fill_amount", progress)
		return
	
	progress = clamp(progress + (progress_speed * delta), 0, 1.0)
	_cursor_material.set_shader_parameter("fill_amount", progress)
	
	if progress >= 1 and !_in_dialogue:
		_in_dialogue = true
		GameUi.toggle_cursor()
		GameUi.dialogue_ended.connect(on_dialogue_ended)
		GameUi.play_dialogue(collider.dialogue.data)
	return

func on_dialogue_ended() -> void:
	GameUi.dialogue_ended.disconnect(on_dialogue_ended)
	
	_cursor_material.set_shader_parameter("fill_amount", 0)
	GameUi.toggle_cursor()
	progress = 0
	_in_dialogue = false
	return
