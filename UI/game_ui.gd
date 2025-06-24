extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialogue_panel: ColorRect = $AnimationPlayer/Background
@onready var dialogue_text: RichTextLabel = $AnimationPlayer/DialogueText
@onready var interactive_object_name: RichTextLabel = $AnimationPlayer/InteractiveObjectName
@onready var search_cursor: Control = $AnimationPlayer/SearchCursor

func play_transition(inbetween: Callable) -> void:
	animation_player.play("glitch")
	inbetween.call()
	animation_player.play_backwards("glitch")
	return
	
func show_cursor() -> void:
	animation_player.play("show_search_cursor")
	return

func show_interactive_object_name(name: String) -> void:
	interactive_object_name.text = name
	animation_player.play("show_interactive_object_name")
	return
	
func hide_interactive_object_name() -> void:
	animation_player.play_backwards("show_interactive_object_name")
	return

func play_dialogue(message: String) -> void:
	dialogue_text.visible_ratio = 0
	
	if !dialogue_panel.visible:
		animation_player.play("blackout")
		
	dialogue_text.text = message
	animation_player.play("show_dialogue")
	return
