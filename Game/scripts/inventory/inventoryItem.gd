extends Resource
class_name InventoryItem

enum ItemType {POTION, INGREDIENT}

@export var name: String = ""
@export var description: String = ""
@export var texture: Texture2D
@export var type:ItemType = ItemType.POTION
@export var getSound:AudioStream
