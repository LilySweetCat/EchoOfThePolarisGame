extends Area3D

@export var is_tracking : bool = true

@export var player: CharacterController
@export var main_camera: Camera3D
@export var virtual_camera: Camera3D

@export var Echo: EchoController
@export var EchoLocation: Node3D

var is_current : bool

@onready var tracking_target : Node3D = player.get_node("TrackTarget");

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	#print(tracking_target.name)
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is not CharacterController and is_current:
		return
		
	#var tween = create_tween()
	#tween.tween_property(main_camera, "transform", virtual_camera.transform, 0.5)
	
	GameUi.play_transition()
	main_camera.transform = virtual_camera.transform
	is_current = true
	
	if Echo and EchoLocation:
		Echo.pause = true
		
		var tween = create_tween()
		tween.tween_property(Echo.particle_system, "amount_ratio", 0, 1)
		
		tween.step_finished.connect(
			func(idx: int):
				print(idx)
				Echo.global_transform = EchoLocation.global_transform
				return
		)
		
		tween.tween_property(Echo.particle_system, "amount_ratio", 1, 1)
		tween.finished.connect(
			func():
				Echo.pause = false
				return
		)
	return # Replace with function body.

func _on_body_exited(body: Node3D) -> void:
	if body is not CharacterController:
		return
	is_current = false
	return

func _physics_process(delta: float) -> void:
	if !is_tracking or !is_current:
		return
	main_camera.look_at(tracking_target.global_position)
	return
