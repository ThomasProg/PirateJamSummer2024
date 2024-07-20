extends Area3D
class_name ThrownPotion

#@export var particlesPrefab:PackedScene
@export var sprite:Sprite3D
var velocity:Vector3

var skillOwner = null

signal onExplode()

func _on_body_entered(body):
	if (skillOwner == body):
		return
		
	onExplode.emit()
		
	queue_free()

func _physics_process(delta):
	global_position += velocity * delta
	
