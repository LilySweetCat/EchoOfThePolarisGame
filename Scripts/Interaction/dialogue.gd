extends BaseInteractable

@export var dialogue : Array[String]

func on_interact() -> void:
	super.on_interact()
	GameUi.play_dialogue(dialogue)
	return
