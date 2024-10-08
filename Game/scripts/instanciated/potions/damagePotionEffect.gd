extends PotionEffect

@export var workingAgainstEyeColor:Wolf.EyeColor = Wolf.EyeColor.RED 
@export var potionDamage:float = 2.0

# Called when the node enters the scene tree for the first time.
func runEffect():
	playUseSFX(potionUseSFX, self)
	spawnParticles()
	await get_tree().physics_frame
	await get_tree().physics_frame
	queue_free()

func _on_area_entered(area):
	if area is Wolf:
		if area.visible and area.eyeColor == workingAgainstEyeColor:
			print("Damaging potion threw to the Wolf!")
			area.aggro -= potionDamage
			area.onAggroUpdated()
			area.disappear(true)
			area.setRandomEyeColor()
			
