extends SpotLight3D

@export var audio_player: AudioStreamPlayer3D

@export var min_delay: float = 0.2
@export var max_delay: float = 1.5

#@export var min_energy: float = 0.0
#@export var max_energy: float = 1.0

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.timeout.connect(blink_loop)
	add_child(timer)
	timer.start(randf_range(min_delay, max_delay))
	return

func blink_loop():
	visible = !visible
	audio_player.play()
	timer.start(randf_range(min_delay, max_delay))
	return
