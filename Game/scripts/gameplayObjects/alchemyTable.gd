extends Area3D
class_name AlchemyTable

@export var timeForPotion:float = 10.0
var isPlayerIn:bool = false

func _on_body_entered(body):
	if body is Player:
		isPlayerIn = true
		for child in body.get_children():
			if child is AlchemyTableInteractor:
				child.onAreaEntered(self)


func _on_body_exited(body):
	if body is Player:
		isPlayerIn = false
		for child in body.get_children():
			if child is AlchemyTableInteractor:
				child.onAreaExited(self)
