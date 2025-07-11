extends BaseInteractable

@export var current_camera : Camera3D
@export var inspect_camera : Camera3D

#@export var look_at: Node3D
@export var path_follow: PathFollow3D

@export var move_speed: float = 1.0
@export var smoothness: float = 5.0

@export var disable_nodes: Array[Node3D] = []

var _target_progress: float = 0.5  # начальная позиция в середине

var _enable_camera_movement: bool

func _ready() -> void:
	super._ready()
	_target_progress = path_follow.progress_ratio  # инициализируем текущей позицией
	return

func on_interact() -> void:
	super.on_interact()
	inspect_camera.current = true
	_enable_camera_movement = true
	
	GameUi.toggle_cursor()
	
	for node_to_disable in disable_nodes:
		node_to_disable.visible = false
		node_to_disable.set_process(false)
		node_to_disable.set_process_input(false)
		node_to_disable.set_process_unhandled_input(false)
	return

func _physics_process(delta: float) -> void:
	if !_enable_camera_movement:
		return
		
	# Получаем ввод (A/D или стрелки влево/вправо)
	var input : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Изменяем целевой прогресс (ограничиваем между 0 и 1)
	_target_progress = clamp(_target_progress - input.y * move_speed * delta, 0.0, 1.0)
	
	# Плавно интерполируем текущий прогресс к целевому
	var smooth_value : float = lerp(path_follow.progress_ratio, _target_progress, smoothness * delta)
	path_follow.progress_ratio = smooth_value
	
	#inspect_camera.look_at(look_at.global_position)
	return
