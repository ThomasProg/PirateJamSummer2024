extends Node
class_name PlayerInventory

@export var potionInventory:Inventory = Inventory.new()
@export var ingredientInventory:Inventory = Inventory.new()

func playGetSFX(item:InventoryItem):
	var player = AudioStreamPlayer.new()
	player.stream = item.getSound
	get_parent().add_child(player)
	player.play()
	player.finished.connect(func():
		player.queue_free())

func giveItem(item:InventoryItem)->int:
	potionInventory.items.resize(10)
	ingredientInventory.items.resize(10)
	playGetSFX(item)
	match item.type:
		InventoryItem.ItemType.POTION:
			return potionInventory.addItem(item)
		InventoryItem.ItemType.INGREDIENT:
			return ingredientInventory.addItem(item)
			
	return -1
	
func forceGiveItem(item:InventoryItem):
	var v:int = giveItem(item)
	
	if v == -1:
		match item.type:
			InventoryItem.ItemType.POTION:
				potionInventory.items[0] = item
			InventoryItem.ItemType.INGREDIENT:
				ingredientInventory.items[0] = item
				
			
	

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("GiveDeterringPotion")):
		forceGiveItem(load("res://inventoryAssets/potions/deterringPotion.tres"))
	if (Input.is_action_just_pressed("GiveInvisibilityPotion")):
		forceGiveItem(load("res://inventoryAssets/potions/invisibilityPotion.tres"))		
	if (Input.is_action_just_pressed("GiveRedPotion")):
		forceGiveItem(load("res://inventoryAssets/potions/redPotion.tres"))
	if (Input.is_action_just_pressed("GiveYellowPotion")):
		forceGiveItem(load("res://inventoryAssets/potions/yellowPotion.tres"))
		
	if (Input.is_action_just_pressed("GiveChameleon")):
		forceGiveItem(load("res://inventoryAssets/ingredients/chameleonIngr.tres"))
	if (Input.is_action_just_pressed("GiveStinkhorn")):
		forceGiveItem(load("res://inventoryAssets/ingredients/stinkhornIngr.tres"))
	if (Input.is_action_just_pressed("GiveCalendula")):
		forceGiveItem(load("res://inventoryAssets/ingredients/calendulaIngr.tres"))
	if (Input.is_action_just_pressed("GiveHoney")):
		forceGiveItem(load("res://inventoryAssets/ingredients/honeyIngr.tres"))
