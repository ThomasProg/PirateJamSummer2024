extends Node

@export var potionSprite:Sprite3D
@export var potionSelector:PotionSelector
@export var itemNameText:RichTextLabel
@export var itemDescText:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	
	if (GameManager.isDay):
		return
	
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
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
