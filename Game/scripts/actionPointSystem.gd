extends Node
class_name ActionPointSystem

@export var nbPoints:int = 5
@export var objectifIndex:int = 1

@export var label:RichTextLabel

signal onNoPoints()

func _ready() -> void:
	GameManager.actionPointSystem = self
	updateVisuals()

func removePoint():
	nbPoints -= 1
	if (nbPoints == 0):
		onNoPoints.emit()
		
	updateVisuals()

func updateVisuals():
	label.text = "[center]%d conversations remaining[/center]" % nbPoints
