extends Area3D
class_name Character

@export var interactable:Interactable
@export var sharedDialogue:SharedDialogue

func _ready():
	if (sharedDialogue == null):
		push_warning("No dialogue setup")
		return
		
	interactable.onInteracted.connect(func(player: Player):				
		sharedDialogue.play(self, player)			
		GameManager.actionPointSystem.removePoint()
	)
	
	sharedDialogue.onStarted.connect(func(characterTalkedTo:Character, player: Player):
		interactable.queue_free()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# billboard
	# Can't use the native feature since it doesn't update shadow correctly
	var posToLookAt = get_viewport().get_camera_3d().global_position
	posToLookAt.y = global_position.y
	look_at(posToLookAt, Vector3.UP, true)
