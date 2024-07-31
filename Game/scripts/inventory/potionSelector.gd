extends Node
class_name PotionSelector

@export var currentlySelectedItemIndex:int = 0
@export var playerInv:PlayerInventory

signal onNewItemSelected(InventoryItem)

func getCurrentItem()->InventoryItem:
	return playerInv.potionInventory.items[currentlySelectedItemIndex]
	
func popCurrentItem()->InventoryItem:
	var item = playerInv.potionInventory.items[currentlySelectedItemIndex]
	playerInv.potionInventory.items[currentlySelectedItemIndex] = null
	
	if not(playerInv.potionInventory.isEmpty()):
		selectNextValidItem()
	else:
		onNewItemSelected.emit(null)
	
	return item

func ensureValidIndex():
	currentlySelectedItemIndex = playerInv.potionInventory.ensureValidIndex(currentlySelectedItemIndex)

func selectNextValidItem():
	currentlySelectedItemIndex = playerInv.potionInventory.getNextItemIndex(currentlySelectedItemIndex)
		
	onNewItemSelected.emit(getCurrentItem())
		
func selectItemAtIndex(index:int):
	currentlySelectedItemIndex = index
	ensureValidIndex()
	onNewItemSelected.emit(getCurrentItem())
		
func selectPreviousValidItem():
	currentlySelectedItemIndex = playerInv.potionInventory.getPreviousItemIndex(currentlySelectedItemIndex)
		
	onNewItemSelected.emit(getCurrentItem())

var sensibility:float = 1.0
var currentScrollUp = 0.0
var currentScrollDown = 0.0

func _input(event: InputEvent):
	# prevent infinite loop for searching for valid items
	if (playerInv.potionInventory.isEmpty()):
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
	if not(playerInv.potionInventory.isEmpty()):
		selectNextValidItem()
		
	await get_tree().process_frame
	
	if (GameManager.isDay):
		queue_free()
