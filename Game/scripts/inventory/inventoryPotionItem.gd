extends InventoryItem
class_name InventoryPotionItem

@export var effectPrefab:PackedScene = preload("res://prefabs/instanced/potions/defaultPotionEffectPrefab.tscn")
@export var isThrowable:bool = true
