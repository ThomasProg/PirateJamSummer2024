extends Node

@export var potionSprite:Sprite3D
@export var potionSelector:PotionSelector
@export var itemNameText:RichTextLabel
@export var itemDescText:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	potionSelector.onNewItemSelected.connect(func(item:InventoryItem):
		print("new item: ", item.name)
		potionSprite.texture = item.texture
		itemNameText.text = "[center] %s [/center]" % [item.name]
		itemDescText.text = "[center] %s [/center]" % [item.description]		
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
