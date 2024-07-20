extends Resource
class_name Inventory

@export var items:Array[InventoryItem]

func isEmpty()->bool:
	return items.is_empty()
