extends PotionEffect

@export var duration:float = 5.0

# Called when the node enters the scene tree for the first time.
func runEffect():
	spawnParticles()
	await get_tree().create_timer(duration).timeout
	queue_free()

func _on_area_entered(area):
	if area is Wolf:
		if area.visible:
			area.disappear()
