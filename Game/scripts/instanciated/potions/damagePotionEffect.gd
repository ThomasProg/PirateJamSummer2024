extends PotionEffect

@export var workingAgainstEyeColor:Wolf.EyeColor = Wolf.EyeColor.RED 
@export var potionDamage:float = 5.0

# Called when the node enters the scene tree for the first time.
func runEffect():
	spawnParticles()
	await get_tree().physics_frame
	await get_tree().physics_frame
	queue_free()

func _on_area_entered(area):
	if area is Wolf:
		if area.visible and area.eyeColor == workingAgainstEyeColor:
			area.aggro -= potionDamage
			area.onAggroUpdated()
			print("Wolf attacked!")
