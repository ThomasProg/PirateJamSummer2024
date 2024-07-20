extends Resource
class_name Inventory

@export var items:Array[InventoryItem]

func isEmpty()->bool:
	return items.all(func(item): return item == null)

func addItem(newItem:InventoryItem) -> int:
	for i in range(items.size()):
		if (items[i] == null):
			items[i] = newItem
			return i

	return -1
