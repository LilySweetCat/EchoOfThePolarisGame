extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var search_cursor: Control = $AnimationPlayer/SearchCursor
@onready var search_cursor_texts : Array[RichTextLabel] = [
	$AnimationPlayer/SearchCursor/TopLeft,
	$AnimationPlayer/SearchCursor/TopRight,
	$AnimationPlayer/SearchCursor/BottomLeft,
	$AnimationPlayer/SearchCursor/BottomRight
]

@onready var typewriter: AudioStreamPlayer = $Typewriter

@onready var interactive_object_name: RichTextLabel = $InteractiveObjectName

@onready var background: ColorRect = $Background
@onready var dialogue_text: RichTextLabel = $Background/DialogueText
@onready var previous_dialogue: Button = $Background/PreviousDialogue
@onready var next_dialogue: Button = $Background/NextDialogue

@onready var buttons_container: VBoxContainer = $Background/ButtonsContainer
@export var action_button = preload("res://UI/action_button.tscn")

# signals
signal dialogue_ended

# private
var _tween : Tween
#var _is_require_input : bool
#var _on_input : Callable

var _dialogue : Array
var _current_dialogue_index : int = 0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	return
	
#func _input(event: InputEvent) -> void:
#	if !event.is_action_pressed("interact") or !_is_require_input:
#		return
#	_on_input.call_deferred()
#	return

func blackout() -> Tween:
	var tween = create_tween()
	tween.tween_property(background, "color", Color.BLACK, 0.2)
	return tween
	
func disable_blackout() -> Tween:
	var tween = create_tween()
	tween.tween_property(background, "color", Color.TRANSPARENT, 0.2)
	return tween
	
func play_previous_dialogue_line() -> void:
	# -2 - т.к. если при play_dialogue_line идет +1 т.е. следующий фрагмент
	# и -1 просто сделает так что отобразится текущий диалог
	_current_dialogue_index = _current_dialogue_index - 2
	
	if _current_dialogue_index < 0:
		_current_dialogue_index = 0
		
	call_deferred("play_dialogue_line")
	return
	
func play_dialogue_line() -> void:
	if _tween:
		_tween.kill()
	
	if _current_dialogue_index != 0:
		play_transition()
	
	if _current_dialogue_index >= _dialogue.size():
		print("all dialogue parts played")
		#_is_require_input = false
		dialogue_text.visible_ratio = 0
		
		previous_dialogue.pressed.disconnect(play_previous_dialogue_line)
		next_dialogue.pressed.disconnect(play_dialogue_line)
		
		next_dialogue.self_modulate = Color.TRANSPARENT
		next_dialogue.visible = false
		previous_dialogue.self_modulate = Color.TRANSPARENT
		previous_dialogue.visible = false
		
		disable_blackout()
		dialogue_ended.emit()
		return
	
	print("playing dialogue part: %d" % [_current_dialogue_index])
	var current_dialogue_data : Dictionary = _dialogue[_current_dialogue_index]
	var current_dialogue_text : String = current_dialogue_data.get("text")
	var is_reading = current_dialogue_data.get("is_reading")
	
	_current_dialogue_index += 1
	
	dialogue_text.visible_ratio = 0
	dialogue_text.text = current_dialogue_text
	
	next_dialogue.self_modulate = Color.TRANSPARENT
	next_dialogue.visible = true
	next_dialogue.call_deferred("grab_focus")
	
	if is_reading:
		dialogue_text.self_modulate = Color.WHITE
		dialogue_text.visible_ratio = 1.0
		
		next_dialogue.self_modulate = Color.WHITE
		
		previous_dialogue.self_modulate = Color.WHITE
		previous_dialogue.visible = true
		return
	
	_tween = create_tween().set_parallel(true)
	
	_tween.tween_property(dialogue_text, "self_modulate", Color.WHITE, 0.5)
	_tween.tween_property(dialogue_text, "visible_ratio", 1.0, current_dialogue_text.length()/12)
	
	_tween.chain().tween_property(next_dialogue, "self_modulate", Color.WHITE, 0.5)
	
	return

func play_dialogue(dialogue: Array) -> void:
	blackout()
	
	_dialogue = dialogue
	_current_dialogue_index = 0
	
	if previous_dialogue.pressed.is_connected(play_previous_dialogue_line):
		previous_dialogue.pressed.disconnect(play_previous_dialogue_line)
	if next_dialogue.pressed.is_connected(play_dialogue_line):
		next_dialogue.pressed.disconnect(play_dialogue_line)
	
	previous_dialogue.pressed.connect(play_previous_dialogue_line)
	next_dialogue.pressed.connect(play_dialogue_line)
	#_is_require_input = true
	#_on_input = play_next_dialogue_line
	play_dialogue_line()
	return
	
func hide_actions() -> void:
	for child in buttons_container.get_children():
		child.queue_free()
		
	disable_blackout()
	return

func show_actions(actions: Dictionary, free_after_press: bool) -> void:
	for child in buttons_container.get_children():
		child.queue_free()
	
	blackout()
	
	for action_name in actions:
		print(action_name)
		var new_action_button : Button = action_button.instantiate()
		
		var corrected_action : Callable = actions[action_name]
		if free_after_press:
			corrected_action = func():
				actions[action_name].call_deferred()
				hide_actions()
		
		new_action_button.text = action_name
		new_action_button.pressed.connect(corrected_action)
		
		buttons_container.add_child(new_action_button)
		new_action_button.grab_focus()
	return

func show_cursor_data(texts: Array[String]) -> void:
	for index in range(search_cursor_texts.size()):
		search_cursor_texts[index].text = texts[index]
		
	animation_player.queue("show_search_cursor_data")
	return

func play_transition() -> void:
	animation_player.queue("glitch")
	return
	
func show_cursor() -> void:
	animation_player.queue("show_search_cursor")
	return

func show_interactive_object_name(object_name: String) -> void:
	interactive_object_name.text = object_name
	
	typewriter.play()
	
	var tween = create_tween()
	tween.tween_property(interactive_object_name, "visible_ratio", 1.0, object_name.length()/4)
	tween.finished.connect(func(): typewriter.stop())
	return
	
func hide_interactive_object_name() -> void:
	var tween = create_tween()
	tween.tween_property(interactive_object_name, "visible_ratio", 0.0, 0.2)
	return
