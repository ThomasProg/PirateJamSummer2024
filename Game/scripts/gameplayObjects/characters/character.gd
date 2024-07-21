extends Area3D

@export var interactable:Interactable
@export var timeline:DialogicTimeline

func _ready():
	interactable.onInteracted.connect(func(player: Player):
		if (timeline == null):
			push_error("timeline not set in ", name)
			return
			
		Dialogic.start(timeline)
		get_viewport().set_input_as_handled()
		player.blockMouseCapture = true
		player.captureMouse = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		var interactComp = Utilities.findComponentByType(player, InteractionComponent) as InteractionComponent
		if (interactComp != null):
			interactComp.enabled = false
			
		Dialogic.timeline_ended.connect(func():
			player.blockMouseCapture = false
			
			await get_tree().process_frame
			interactComp.enabled = true
			, CONNECT_ONE_SHOT)
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# billboard
	# Can't use the native feature since it doesn't update shadow correctly
	var posToLookAt = get_viewport().get_camera_3d().global_position
	posToLookAt.y = global_position.y
	look_at(posToLookAt, Vector3.UP, true)
