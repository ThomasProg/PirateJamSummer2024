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
	playGetSFX(item)
	match item.type:
		InventoryItem.ItemType.POTION:
			return potionInventory.addItem(item)
		InventoryItem.ItemType.INGREDIENT:
			return ingredientInventory.addItem(item)
			
	return -1

func _input(event: InputEvent) -> void:
	if (Input.is_action_pressed("GiveDeterringPotion")):
		giveItem(load("res://inventoryAssets/potions/deterringPotion.tres"))
	if (Input.is_action_pressed("GiveInvisibilityPotion")):
		giveItem(load("res://inventoryAssets/potions/invisibilityPotion.tres"))		
	if (Input.is_action_pressed("GiveRedPotion")):
		giveItem(load("res://inventoryAssets/potions/redPotion.tres"))
	if (Input.is_action_pressed("GiveYellowPotion")):
		giveItem(load("res://inventoryAssets/potions/yellowPotion.tres"))
		
	if (Input.is_action_pressed("GiveChameleon")):
		giveItem(load("res://inventoryAssets/ingredients/chameleonIngr.tres"))
	if (Input.is_action_pressed("GiveStinkhorn")):
		giveItem(load("res://inventoryAssets/ingredients/stinkhornIngr.tres"))
	if (Input.is_action_pressed("GiveCalendula")):
		giveItem(load("res://inventoryAssets/ingredients/calendulaIngr.tres"))
	if (Input.is_action_pressed("GiveHoney")):
		giveItem(load("res://inventoryAssets/ingredients/honeyIngr.tres"))
