extends Node

@export var potionSelector: PotionSelector
@export var thrownPotionPrefab: PackedScene
@export var camera:Camera3D
@export var defaultSpeed:float = 20.0

func _ready() -> void:
	await get_tree().process_frame
	
	if (GameManager.isDay):
		queue_free()

func _input(event):
	if (GameManager.isDay or potionSelector == null):
		return
	
	if (Input.is_action_just_pressed("ThrowPotion")):
		var item = potionSelector.popCurrentItem()
		if item is InventoryPotionItem:
			if not(item.isThrowable):
				var effect = item.effectPrefab.instantiate() as PotionEffect
				get_parent().add_child(effect)
				effect.skillOwner = get_parent()
				effect.runEffect()
			else:	
				var thrownPotion = thrownPotionPrefab.instantiate()	as ThrownPotion
				get_parent().get_parent().add_child(thrownPotion)
				thrownPotion.sprite.texture = item.texture
				thrownPotion.global_position = camera.global_position
				thrownPotion.skillOwner = get_parent()
				thrownPotion.velocity = - camera.get_global_transform().basis.z * defaultSpeed
				
				thrownPotion.onExplode.connect(func():
					var effect = item.effectPrefab.instantiate()
					thrownPotion.get_parent().add_child(effect)
					effect.global_position = thrownPotion.global_position
					effect.skillOwner = get_parent()
					effect.runEffect()
					)
