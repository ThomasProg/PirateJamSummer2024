extends PotionEffect

@export var duration:float = 5.0

# Called when the node enters the scene tree for the first time.
func runEffect():
	playUseSFX(potionUseSFX, skillOwner)
	skillOwner.nbInvisibleEffects += 1
	skillOwner.updateInvisibility()
	await get_tree().create_timer(duration).timeout
	skillOwner.nbInvisibleEffects -= 1
	skillOwner.updateInvisibility()
	queue_free()
