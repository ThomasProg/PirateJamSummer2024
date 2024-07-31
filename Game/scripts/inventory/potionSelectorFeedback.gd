extends Node

@export var potionSprite:Sprite3D
@export var potionSelector:PotionSelector
@export var itemNameText:RichTextLabel
@export var itemDescText:RichTextLabel

@export var prevItemSlot:InventorySlot
@export var currentItemSlot:InventorySlot
@export var nextItemSlot:InventorySlot

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	
	if (GameManager.isDay):
		return
	
	prevItemSlot.visible = true
	currentItemSlot.visible = true
	nextItemSlot.visible = true
	
	potionSelector.onNewItemSelected.connect(func(item:InventoryItem):
		if (item == null):
			itemNameText.visible = false
			itemDescText.visible = false
			potionSprite.visible = false
			return
		
		print("new item: ", item.name)
		potionSprite.texture = item.texture
		
		potionSprite.visible = true
		itemNameText.visible = true
		itemDescText.visible = true
		itemNameText.text = "[center] %s [/center]" % [item.name]
		itemDescText.text = "[center] %s [/center]" % [item.description]	
		
		var inv = potionSelector.playerInv.potionInventory
		var prevPotion = inv.items[inv.getPreviousItemIndex(potionSelector.currentlySelectedItemIndex)]
		var currentPotion = inv.items[potionSelector.currentlySelectedItemIndex]
		var nextPotion = inv.items[inv.getNextItemIndex(potionSelector.currentlySelectedItemIndex)]
		
		prevItemSlot.setItem(prevPotion)
		currentItemSlot.setItem(currentPotion)
		nextItemSlot.setItem(nextPotion)
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
