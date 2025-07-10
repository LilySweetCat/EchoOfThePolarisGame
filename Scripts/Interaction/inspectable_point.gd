class_name FollowWithClues
extends PathFollow3D

@export var clue_points: Array[CluePoint] = []
@export var event_name: String

var enable_update: bool = true
signal progress_ratio_changed

func _ready() -> void:
	progress_ratio_changed.connect(on_progress_ratio_changed)
	GameUi.dialogue_started.connect(on_dialogue_started)

func on_dialogue_started(event: String):
	if event != event_name:
		return
	enable_update = false

func change_progress_ratio_and_notify(new_value: float) -> void:
	if new_value == progress_ratio:
		return
	
	progress_ratio = new_value
	progress_ratio_changed.emit(new_value)

func in_clue_point_range(point: CluePoint):
	return progress_ratio > (point.path_ratio - point.delta) and progress_ratio <= (point.path_ratio + point.delta)
	
func on_progress_ratio_changed(new_value: float) -> void:
	if !enable_update:
		return
	
	var point_idx = clue_points.find_custom(in_clue_point_range)
	
	if point_idx == -1:
		return
	
	var point = clue_points[point_idx]
	#print(dialogue.data[0]["text"])
	GameUi.play_dialogue(point.dialogue.data, event_name)
	GameUi.dialogue_ended.connect(on_dialogue_ended)
	return

func on_dialogue_ended() -> void:
	GameUi.dialogue_ended.disconnect(on_dialogue_ended)
	enable_update = true
	return
