extends RayCast3D

@export var progress_speed: float = 0.1
@export var progress: float = 0.0

var _disable_scan: bool
var _cursor_material: ShaderMaterial
var _timer: Timer

func _ready() -> void:
	_cursor_material = GameUi.cursor.material
	
	_timer = Timer.new()
	_timer.wait_time = 1
	_timer.one_shot = true
	_timer.timeout.connect(on_timeout)
	self.add_child(_timer)

func on_timeout() -> void:
	_cursor_material.set_shader_parameter("fill_amount", 0)
	GameUi.toggle_cursor()
	progress = 0
	_disable_scan = false

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
	
	if progress >= 1 and !_disable_scan:
		_disable_scan = true
		GameUi.toggle_cursor()
		GameUi.dialogue_ended.connect(on_dialogue_ended)
		GameUi.play_dialogue(collider.dialogue.data)
	return

func on_dialogue_ended() -> void:
	GameUi.dialogue_ended.disconnect(on_dialogue_ended)
	_timer.start(1)
	return
