extends Node
class_name PotionSelector

@export var currentlySelectedItemIndex:int = 0
@export var inventory:Inventory

signal onNewItemSelected(InventoryItem)

func getCurrentItem()->InventoryItem:
	return inventory.items[currentlySelectedItemIndex]
	
func popCurrentItem()->InventoryItem:
	var item = inventory.items[currentlySelectedItemIndex]
	inventory.items[currentlySelectedItemIndex] = null
	
	if not(inventory.isEmpty()):
		selectNextValidItem()
	else:
		onNewItemSelected.emit(null)
	
	return item

func ensureValidIndex():
	var nbItems = inventory.items.size()
	currentlySelectedItemIndex = (currentlySelectedItemIndex % nbItems + nbItems) % nbItems

func selectNextValidItem():
	assert(not(inventory.isEmpty()))
	currentlySelectedItemIndex += 1
	ensureValidIndex()
	
	while (getCurrentItem() == null):
		currentlySelectedItemIndex += 1
		ensureValidIndex()
		
	onNewItemSelected.emit(getCurrentItem())
		
func selectItemAtIndex(index:int):
	currentlySelectedItemIndex = index
	ensureValidIndex()
	onNewItemSelected.emit(getCurrentItem())
		
func selectPreviousValidItem():
	assert(not(inventory.isEmpty()))
	currentlySelectedItemIndex -= 1
	ensureValidIndex()
	
	while (getCurrentItem() == null):
		currentlySelectedItemIndex -= 1
		ensureValidIndex()
		
	onNewItemSelected.emit(getCurrentItem())

var sensibility:float = 1.0
var currentScrollUp = 0.0
var currentScrollDown = 0.0

func _input(event: InputEvent):
	# prevent infinite loop for searching for valid items
	if (inventory.isEmpty()):
		return
	
	if Input.is_action_just_released("NextItem"):
		currentScrollDown = 0.0
		currentScrollUp += sensibility
		if (currentScrollUp >= 1.0):
			selectNextValidItem()
			currentScrollUp = 0.0

	if Input.is_action_just_released("PreviousItem"):
		currentScrollUp = 0.0
		currentScrollDown += sensibility
		if (currentScrollDown >= 1.0):
			selectPreviousValidItem()
			currentScrollDown = 0.0
		


# Called when the node enters the scene tree for the first time.
func _ready():
	selectNextValidItem()
