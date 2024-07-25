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

func canConsumeItems(itemsToConsume:Array[InventoryItem]) -> bool:
	var itemsCopy = items.duplicate(false)
	for ingr in itemsToConsume:
		var index = itemsCopy.find(ingr)
		if (index == -1):
			return  false
		itemsCopy.remove_at(index)
		
	return true

func tryConsumeItems(itemsToConsume:Array[InventoryItem]) -> bool:
	var itemsCopy = items.duplicate(false)
	for ingr in itemsToConsume:
		var index = itemsCopy.find(ingr)
		if (index == -1):
			return  false
		itemsCopy.remove_at(index)
		
	items = itemsCopy
	return true
