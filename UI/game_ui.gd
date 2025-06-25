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

@onready var buttons_container: VBoxContainer = $Background/ButtonsContainer
@export var action_button = preload("res://UI/action_button.tscn")

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	return
	
func play_dialogue(dialogue: Array[String]) -> void:
	var tween = create_tween()
	tween.tween_property(background, "color", Color.BLACK, 0.2)
	
	return
	
func hide_actions() -> void:
	for child in buttons_container.get_children():
		child.queue_free()
		
	var tween = create_tween()
	tween.tween_property(background, "color", Color.TRANSPARENT, 0.2)
	return

func show_actions(actions: Dictionary, free_after_press: bool) -> void:
	for child in buttons_container.get_children():
		child.queue_free()
	
	var tween = create_tween()
	tween.tween_property(background, "color", Color.BLACK, 0.2)
	
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

func show_interactive_object_name(name: String) -> void:
	interactive_object_name.text = name
	
	typewriter.play()
	
	var tween = create_tween()
	tween.tween_property(interactive_object_name, "visible_ratio", 1.0, name.length()/5)
	tween.finished.connect(func(): typewriter.stop())
	return
	
func hide_interactive_object_name() -> void:
	var tween = create_tween()
	tween.tween_property(interactive_object_name, "visible_ratio", 0.0, name.length()/5)
	return
