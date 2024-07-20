extends Node

@export var interactionRaycast:RayCast3D
@export var interactionNameText:RichTextLabel
@export var interactionDescText:RichTextLabel

var collidedLastFrame:bool = false

func _physics_process(delta):
	var isCollidingThisFrame:bool = false
	var interactedBody = interactionRaycast.get_collider() as Node3D
	var currentlyAimedInteractable = null
	if (interactedBody):
		for child in interactedBody.get_children():
			if child is Interactable:
				currentlyAimedInteractable = child
				interactionNameText.text = "[center]" + child.interactionName + "[/center]"
				interactionNameText.visible = true
				interactionDescText.text = "[center]" + child.interactionDescription + "[/center]"
				interactionDescText.visible = true
				
				isCollidingThisFrame = true
				break
				
	if (not(isCollidingThisFrame) and collidedLastFrame):
		interactionNameText.visible = false
		interactionDescText.visible = false
				
	collidedLastFrame = isCollidingThisFrame

	if Input.is_action_just_pressed("Interact") and currentlyAimedInteractable:
		currentlyAimedInteractable.onInteracted.emit(get_parent())
