extends Node

@export var potionSelector: PotionSelector
@export var thrownPotionPrefab: PackedScene
@export var camera:Camera3D
@export var defaultSpeed:float = 20.0

func _input(event):
	if (Input.is_action_just_pressed("ThrowPotion")):
		var item = potionSelector.popCurrentItem()
		if (item != null):
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
				effect.runEffect()
				)
