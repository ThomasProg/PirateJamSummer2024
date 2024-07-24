extends Node
class_name StoryLineDialogue

@export var dialogue:SharedDialogue
@export var baseStoryLine:StoryLine

# Called when the node enters the scene tree for the first time.
func _ready():
	var storyLine = StoryLine.loadStoryLine(baseStoryLine)
	dialogue.timeline = storyLine.getCurrentTimeline()
	
	dialogue.onFinished.connect(func(characterTalkedTo:Character, player:Player):
		storyLine.currentTimelineIndex += 1
		storyLine.saveStoryLine()
		)


