extends Node

@export var potionSprite:Sprite3D
@export var potionSelector:PotionSelector
@export var itemNameText:RichTextLabel
@export var itemDescText:RichTextLabel

@export var slotBar:HBoxContainer
@export var slotPrefab:PackedScene = preload("res://prefabs/inventory/inventorySlot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	
	if (GameManager.isDay):
		return
	
	potionSelector.playerInv.potionInventory.onUpdated.connect(refresh)
	
	potionSelector.onNewItemSelected.connect(func(item:InventoryItem):
		if (item == null):
			itemNameText.visible = false
			itemDescText.visible = false
			potionSprite.visible = false
			
			refresh()
			return
		
		print("new item: ", item.name)
		potionSprite.texture = item.texture
		
		potionSprite.visible = true
		itemNameText.visible = true
		itemDescText.visible = true
		itemNameText.text = "[center] %s [/center]" % [item.name]
		itemDescText.text = "[center] %s [/center]" % [item.description]	
		
		refresh()
		)

func refresh():
	for child in slotBar.get_children():
		child.queue_free()
	
	if (potionSelector.playerInv.potionInventory.isEmpty()):
		return

	for potionStack in potionSelector.playerInv.potionInventory.items:
		if (potionStack != null):
			var slot:InventorySlot = slotPrefab.instantiate()
			slot.setStack(potionStack)
			slotBar.add_child(slot)
