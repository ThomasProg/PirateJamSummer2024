extends Node3D

@export var toResetColliders:Node3D
@export var door:Node3D
@export var thatch:Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = toResetColliders.find_children("*", "StaticBody3D", true, false)
	for child in children:
		child.position = Vector3.ZERO

	await get_tree().process_frame
	
	if (GameManager.isDay):
		door.rotate_y(deg_to_rad(-150.0))
