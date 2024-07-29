extends Node
class_name InteractionComponent

@export var interactionRaycast:RayCast3D
@export var parent:Control
@export var interactionNameText:RichTextLabel
@export var interactionDescText:RichTextLabel

var collidedLastFrame:bool = false
var enabled = true

func hideFeedback():
	parent.visible = false
	interactionNameText.visible = false
	interactionDescText.visible = false

func _physics_process(delta):
	if not(enabled):
		hideFeedback()
		return
	
	var isCollidingThisFrame:bool = false
	var interactedBody = interactionRaycast.get_collider() as Node3D
	var currentlyAimedInteractable = null
	if (interactedBody):
		var interactable = Utilities.findComponentByType(interactedBody, Interactable)
		if (interactable != null):
			currentlyAimedInteractable = interactable
			interactionNameText.text = "[center]" + interactable.interactionName + "[/center]"
			interactionNameText.visible = true
			interactionDescText.text = "[center]" + interactable.interactionDescription + "[/center]"
			interactionDescText.visible = true
			parent.visible = true
			
			isCollidingThisFrame = true
				
	if (not(isCollidingThisFrame) and collidedLastFrame):
		hideFeedback()
				
	collidedLastFrame = isCollidingThisFrame

	if Input.is_action_just_pressed("Interact") and currentlyAimedInteractable:
		currentlyAimedInteractable.onInteracted.emit(get_parent())
