extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialogue_panel: ColorRect = $AnimationPlayer/Background
@onready var dialogue_text: RichTextLabel = $AnimationPlayer/DialogueText
@onready var interactive_object_name: RichTextLabel = $AnimationPlayer/InteractiveObjectName

@onready var search_cursor: Control = $AnimationPlayer/SearchCursor
@onready var search_cursor_texts : Array[RichTextLabel] = [
	$AnimationPlayer/SearchCursor/TopLeft,
	$AnimationPlayer/SearchCursor/TopRight,
	$AnimationPlayer/SearchCursor/BottomLeft,
	$AnimationPlayer/SearchCursor/BottomRight
]

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	return

func show_cursor_data(texts: Array[String]) -> void:
	for index in range(texts.size()):
		search_cursor_texts[index].text = texts[index]
		
	animation_player.queue("show_search_cursor_data")
	return

func play_transition(inbetween: Callable) -> void:
	animation_player.queue("glitch")
	inbetween.call()
	animation_player.play_backwards("glitch")
	return
	
func show_cursor() -> void:
	animation_player.queue("show_search_cursor")
	return

func show_interactive_object_name(name: String) -> void:
	interactive_object_name.text = name
	animation_player.queue("show_interactive_object_name")
	return
	
func hide_interactive_object_name() -> void:
	animation_player.play_backwards("show_interactive_object_name")
	return

func play_dialogue(message: String) -> void:
	dialogue_text.visible_ratio = 0
	
	if !dialogue_panel.visible:
		animation_player.queue("blackout")
		
	dialogue_text.text = message
	animation_player.queue("show_dialogue")
	return
