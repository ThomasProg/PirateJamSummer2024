extends Node
class_name Interactable

@export var interactionName:String = "Click to [...]"
@export var interactionDescription:String = "Click to [...]"

signal onInteracted(player:Player)

