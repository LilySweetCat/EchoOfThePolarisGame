extends BaseInteractable

@export var dialogue : JSON

func on_interact() -> void:
	super.on_interact()
	
	#print(dialogue.data[0]["text"])
	GameUi.play_dialogue(dialogue.data)
	GameUi.dialogue_ended.connect(on_dialogue_ended)
	
	return

func on_dialogue_ended() -> void:
	GameUi.dialogue_ended.disconnect(on_dialogue_ended)
	super.on_cancel()
	return
