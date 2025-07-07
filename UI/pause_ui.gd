class_name PauseUI
extends Control

enum pause_menu_page {
	main,
	possessions,
	mental_notes,
	personal_history
}

@export var min_possession_items : int = 10
@export var inventory_button_prefab = preload("res://UI/inventory_button.tscn")

var _current_menu : pause_menu_page = pause_menu_page.main

func _ready() -> void:
	visible = false
	modulate = Color.TRANSPARENT
	
	%Exit.pressed.connect(exit_pressed)
	%Current_Possessions.pressed.connect(toggle_possessions)
	return
	
func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("ui_cancel"):
		return
	
	exit_pressed()
	return
	
func toggle_possessions() -> void:
	%ItemName.text = "Пусто"
	%ItemDescription.text = "Ничего не выбрано"
					
	var buttons: Array[Node] = %Items.get_children()
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	if !%Possessions.visible:
		_current_menu = pause_menu_page.possessions
		
		%Possessions.visible = true
		%Possessions.modulate = Color.TRANSPARENT
		
		%ItemName.visible_ratio = 0
		%ItemDescription.visible_ratio = 0
		
		var storage_inventory: Array[InventoryItem] = Storage.inventory
		for item_idx in range(Storage.inventory.size()):
			var inventory_button = inventory_button_prefab.instantiate()
			var storage_inventory_item = storage_inventory[item_idx]
			
			inventory_button.icon = storage_inventory_item.texture
			inventory_button.pressed.connect(
				func():
					%ItemName.visible_ratio = 0
					%ItemDescription.visible_ratio = 0
					
					%ItemName.text = storage_inventory_item.name
					%ItemDescription.text = storage_inventory_item.description
					
					var button_tween = create_tween()
					button_tween.set_parallel(true)
					button_tween.tween_property(%ItemName, "visible_ratio", 1, 0.5)
					button_tween.tween_property(%ItemDescription, "visible_ratio", 1, 0.5)
					return
			)
			%Items.add_child(inventory_button)
			
		if storage_inventory.size() < min_possession_items:
			var diff = min_possession_items - storage_inventory.size()
			for idx in diff:
				var inventory_button = inventory_button_prefab.instantiate()
				inventory_button.pressed.connect(
				func():
					%ItemName.text = "Пусто"
					%ItemDescription.text = "Ничего не выбрано"
					return
			)
				%Items.add_child(inventory_button)
		
		tween.tween_property(%Possessions, "modulate", Color.WHITE, 0.5)
		tween.tween_property(%Main, "modulate", Color.TRANSPARENT, 0.5)
		tween.tween_property(%ItemName, "visible_ratio", 1, 0.5)
		tween.tween_property(%ItemDescription, "visible_ratio", 1, 0.5)
		
		buttons = %Items.get_children()
		tween.finished.connect(
			func():
				%Main.visible = false
				buttons[0].call_deferred("grab_focus")
				return
		)
	else:
		for button in buttons:
			button.queue_free()
		
		%Main.visible = true
		tween.tween_property(%Main, "modulate", Color.WHITE, 0.5)
		tween.tween_property(%Possessions, "modulate", Color.TRANSPARENT, 0.5)
		tween.tween_property(%ItemName, "visible_ratio", 0.0, 0.5)
		tween.tween_property(%ItemDescription, "visible_ratio", 0.0, 0.5)
		tween.finished.connect(
			func():
				%Possessions.visible = false
				_current_menu = pause_menu_page.main
				
				%Current_Possessions.call_deferred("grab_focus")
				return
		)
	return

func exit_pressed() -> void:
	if _current_menu == pause_menu_page.main:
		toggle_pause_menu()
	if _current_menu == pause_menu_page.possessions:
		toggle_possessions()
	return

func toggle_pause_menu() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	
	if !visible:
		visible = true
		modulate = Color.TRANSPARENT
		%Background.color = Color.TRANSPARENT
		%Background.visible = true
		
		tween.tween_property(self, "modulate", Color.WHITE, 0.5)
		tween.tween_property(%Background, "color", Color.BLACK, 0.5)
		
		tween.finished.connect(
			func():
				%Current_Possessions.call_deferred("grab_focus")
		)
	else:
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
		tween.tween_property(%Background, "color", Color.TRANSPARENT, 0.5)
		
		tween.finished.connect(
			func():
				visible = false
				%Background.visible = false
				return
		)
	return
