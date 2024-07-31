extends Node
class_name ActionPointSystem

@export var nbPoints:int = 5
@export var objectifIndex:int = 1

@export var label:RichTextLabel

signal onNoPoints()

func _ready() -> void:
	GameManager.actionPointSystem = self
	updateVisuals()

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("AddActionPoint")):
		nbPoints += 1
		updateVisuals()

func removePoint():
	if (nbPoints > 0):
		nbPoints -= 1
		if (nbPoints == 0):
			onNoPoints.emit()
			
		updateVisuals()
	
func addPoint():
	nbPoints += 1
	updateVisuals()

func updateVisuals():
	label.text = "[center]%d conversations remaining[/center]" % nbPoints
