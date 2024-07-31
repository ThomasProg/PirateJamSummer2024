extends Node3D
class_name RemovableStone

@export var body:StaticBody3D
@export var peekingSpot:Node3D
@export var peekingAtSpot:Node3D
@export var fadeInDelay:float = 7.5

var timer:SceneTreeTimer = null

func disappear():
	visible = false
	#var body = Utilities.findComponentByType(self, StaticBody3D)
	var collider = Utilities.findComponentByType(body, CollisionShape3D) as CollisionShape3D
	collider.disabled = true
	
	if (timer != null):
		timer.timeout.disconnect(onFadeIn)
		timer = null

	timer = get_tree().create_timer(fadeInDelay)
	timer.timeout.connect(onFadeIn)

func onFadeIn():
	visible = true
	#var body = Utilities.findComponentByType(self, StaticBody3D)
	var collider = Utilities.findComponentByType(body, CollisionShape3D) as CollisionShape3D
	collider.disabled = false
