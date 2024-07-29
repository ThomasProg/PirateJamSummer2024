extends Node

@export var interactable:Interactable
@export var itemToGive:InventoryItem

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.onInteracted.connect(func(player:Player):
		var playerInv = Utilities.findComponentByType(player, PlayerInventory) as PlayerInventory
		match (itemToGive.type):
			InventoryItem.ItemType.POTION:
				playerInv.giveItem(itemToGive)
			InventoryItem.ItemType.INGREDIENT:
				playerInv.giveItem(itemToGive)
			
		get_parent().queue_free()
		)
