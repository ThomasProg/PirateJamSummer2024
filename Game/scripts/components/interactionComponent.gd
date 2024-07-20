extends Node

@export var interactionRaycast:RayCast3D
@export var interactionNameText:RichTextLabel
@export var interactionDescText:RichTextLabel

var collidedLastFrame:bool = false

func _physics_process(delta):
	var isCollidingThisFrame:bool = false
	var interactedBody = interactionRaycast.get_collider() as Node3D
	if (interactedBody):
		for child in interactedBody.get_children():
			if child is Interactable:
				interactionNameText.text = "[center]" + child.interactionName + "[/center]"
				interactionNameText.visible = true
				interactionDescText.text = "[center]" + child.interactionDescription + "[/center]"
				interactionDescText.visible = true
				
				isCollidingThisFrame = true
				
	if (not(isCollidingThisFrame) and collidedLastFrame):
		interactionNameText.visible = false
		interactionDescText.visible = false
				
	collidedLastFrame = isCollidingThisFrame
