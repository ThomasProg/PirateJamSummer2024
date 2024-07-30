extends Area3D
class_name Character

var previousParent:Node = null
@export var interactable:Interactable
@export var sharedDialogue:SharedDialogue

func resetInteractable():
	previousParent.add_child(interactable)

func _ready():
	if (sharedDialogue == null):
		push_warning("No dialogue setup")
		return
		
	interactable.onInteracted.connect(func(player: Player):				
		sharedDialogue.play(self, player)			
	)
	
	sharedDialogue.onStarted.connect(func(characterTalkedTo:Character, player: Player):
		#interactable.queue_free()
		previousParent = interactable.get_parent()
		previousParent.remove_child(interactable)
		)
		
	sharedDialogue.onCancelled.connect(func(characterTalkedTo:Character, player: Player):
		resetInteractable()
		GameManager.actionPointSystem.addPoint()
		)
		
	sharedDialogue.onFinished.connect(func(characterTalkedTo:Character, player: Player):
		GameManager.actionPointSystem.removePoint()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Dialogic.current_timeline == sharedDialogue.timeline:
		visible = false
	else:
		visible = true
	
	# billboard
	# Can't use the native feature since it doesn't update shadow correctly
	var posToLookAt = get_viewport().get_camera_3d().global_position
	posToLookAt.y = global_position.y
	look_at(posToLookAt, Vector3.UP, true)

	if interactable != null and GameManager.actionPointSystem.nbPoints == 0:
		interactable.queue_free()
		interactable = null
