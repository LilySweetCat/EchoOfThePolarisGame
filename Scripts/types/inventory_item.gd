class_name InventoryItem
extends Resource

@export var id: String = "item"  # Уникальный идентификатор
@export var name: String = "Предмет"
@export var texture: Texture2D  # Иконка
@export var description: String = "Описание предмета"

@export var inspect_mesh: PackedScene  # 3D модель для осмотра (если есть)

# Виртуальный метод для использования предмета
func use(player: Node) -> void:
	print("Использован предмет: ", name)
	# Переопределите в наследниках для логики использования
