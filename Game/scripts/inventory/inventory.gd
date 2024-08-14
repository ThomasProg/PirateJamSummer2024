extends Resource
class_name Inventory

@export var items:Array[Stack]

signal onUpdated()

func isEmpty()->bool:
	return items.all(func(item): return item == null)

func addItem(newItem:InventoryItem) -> int:
	# modify count of existing item
	for i in range(items.size()):
		if (items[i] != null and items[i].item == newItem):
			items[i].count += 1
			onUpdated.emit()
			return i

	# add item that doesn't exist yet
	for i in range(items.size()):
		if (items[i] == null):
			items[i] = Stack.new()
			items[i].item = newItem
			items[i].count = 1
			onUpdated.emit()
			return i

	return -1

func copyItems() -> Array[Stack]:
	# TODO : optimize by reserving
	var itemsCopy:Array[Stack] = []
	for item in items:
		if (item != null):
			var newItemCopy = Stack.new()
			newItemCopy.item = item.item
			newItemCopy.count = item.count
			itemsCopy.push_back(newItemCopy)
		else:
			itemsCopy.push_back(null)
			
	return itemsCopy

func canConsumeItems(itemsToConsume:Array[InventoryItem]) -> bool:
	var itemsCopy:Array[Stack] = copyItems()
	
	for ingr in itemsToConsume:
		var bFound = false
		for i in range(itemsCopy.size()):
			var stack:Stack = itemsCopy[i]
			if (stack != null) and (stack.item == ingr):
				bFound = true
				
		if not(bFound):
			return false
		
	return true

func tryConsumeItems(itemsToConsume:Array[InventoryItem]) -> bool:
	var itemsCopy:Array[Stack] = copyItems()
		
	for ingr in itemsToConsume:
		#var index = itemsCopy.find(ingr)
		#if (index == -1):
			#return  false
		#itemsCopy.remove_at(index)
		
		var bFound = false
		for i in range(itemsCopy.size()):
			var stack:Stack = itemsCopy[i]
			if (stack != null) and (stack.item == ingr):
				bFound = true
				stack.count -= 1
				if (stack.count <= 0):
					itemsCopy[i] = null
				
		if not(bFound):
			return false
		
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
