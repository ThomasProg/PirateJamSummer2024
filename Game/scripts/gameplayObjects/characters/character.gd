extends Area3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# billboard
	# Can't use the native feature since it doesn't update shadow correctly
	var posToLookAt = get_viewport().get_camera_3d().global_position
	posToLookAt.y = global_position.y
	look_at(posToLookAt, Vector3.UP, true)
