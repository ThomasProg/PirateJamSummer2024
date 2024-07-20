extends Node
class_name AlchemyTableInteractor

@export var progressBar:ProgressBar
@export var currentProgress:float = 0

var table:AlchemyTable = null

func onAreaEntered(newTable):
	table = newTable
	progressBar.max_value = table.timeForPotion
	
func onAreaExited(newTable):
	table = null	

func _process(delta):
	if (table != null):
		currentProgress += delta
		progressBar.value = currentProgress
		progressBar.visible = true
	else:
		progressBar.visible = false
