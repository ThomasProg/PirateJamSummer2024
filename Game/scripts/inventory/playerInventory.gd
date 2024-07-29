extends Node
class_name PlayerInventory

@export var potionInventory:Inventory = Inventory.new()
@export var ingredientInventory:Inventory = Inventory.new()

func _input(event: InputEvent) -> void:
	if (Input.is_action_pressed("GiveDeterringPotion")):
		potionInventory.addItem(load("res://inventoryAssets/potions/deterringPotion.tres"))
	if (Input.is_action_pressed("GiveInvisibilityPotion")):
		potionInventory.addItem(load("res://inventoryAssets/potions/invisibilityPotion.tres"))		
	if (Input.is_action_pressed("GiveRedPotion")):
		potionInventory.addItem(load("res://inventoryAssets/potions/redPotion.tres"))
	if (Input.is_action_pressed("GiveYellowPotion")):
		potionInventory.addItem(load("res://inventoryAssets/potions/yellowPotion.tres"))
		
	if (Input.is_action_pressed("GiveChameleon")):
		potionInventory.addItem(load("res://inventoryAssets/ingredients/chameleonIngr.tres"))
	if (Input.is_action_pressed("GiveStinkhorn")):
		potionInventory.addItem(load("res://inventoryAssets/ingredients/stinkhornIngr.tres"))
	if (Input.is_action_pressed("GiveCalendula")):
		potionInventory.addItem(load("res://inventoryAssets/ingredients/calendulaIngr.tres"))
	if (Input.is_action_pressed("GiveHoney")):
		potionInventory.addItem(load("res://inventoryAssets/ingredients/honeyIngr.tres"))
