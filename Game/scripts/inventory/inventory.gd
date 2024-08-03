extends Resource
class_name Inventory

@export var items:Array[InventoryItem]

signal onUpdated()

func isEmpty()->bool:
	return items.all(func(item): return item == null)

func addItem(newItem:InventoryItem) -> int:
	for i in range(items.size()):
		if (items[i] == null):
			items[i] = newItem
			onUpdated.emit()
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

func ensureValidIndex(itemIndex:int) -> int:
	var nbItems = items.size()
	return (itemIndex % nbItems + nbItems) % nbItems

func getNextItemIndex(currentItemIndex:int):
	assert(not(isEmpty()))
	currentItemIndex += 1
	currentItemIndex = ensureValidIndex(currentItemIndex)
	
	while (items[currentItemIndex] == null):
		currentItemIndex += 1
		currentItemIndex = ensureValidIndex(currentItemIndex)
		
	return currentItemIndex
		
func getPreviousItemIndex(currentItemIndex:int):
	assert(not(isEmpty()))
	currentItemIndex -= 1
	currentItemIndex = ensureValidIndex(currentItemIndex)
	
	while (items[currentItemIndex] == null):
		currentItemIndex -= 1
		currentItemIndex = ensureValidIndex(currentItemIndex)
				
	return currentItemIndex
