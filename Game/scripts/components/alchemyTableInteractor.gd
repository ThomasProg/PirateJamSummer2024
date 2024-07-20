extends Node
class_name AlchemyTableInteractor

@export var progressBar:ProgressBar
@export var progressBarText:RichTextLabel

var table:AlchemyTable = null

func onAreaEntered(newTable):
	table = newTable
	progressBar.max_value = table.timeForPotion
	
func onAreaExited(newTable):
	table = null	

func _process(delta):
	if (table != null and table.selectedInteractible != null):
		table.addProgress(delta)
		progressBar.value = table.currentProgress
		progressBar.visible = true
		
		var str:String
		if (table.selectedInteractible == table.redPotionInteractible):
			str = "Brewing red potion..."
		elif (table.selectedInteractible == table.yellowPotionInteractible):
			str = "Brewing yellow potion..."
		
		progressBarText.text = "[center]" + str + "[/center]"
	else:
		progressBar.visible = false

