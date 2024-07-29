extends Resource
class_name StoryLine

@export var storyLineName:String = ""
@export var currentTimelineIndex:int = 0
@export var timelines:Array[DialogicTimeline] = []

static func storyLineNameToSavePath(storyLineName:String) -> String:
	assert(not storyLineName.is_empty())
	return "user://%s/%s.res" % [GameManager.currentSaveDir, storyLineName]

static func loadStoryLine(baseStoryLine:StoryLine) -> StoryLine:
	var path:String = storyLineNameToSavePath(baseStoryLine.storyLineName)
	if ResourceLoader.exists(path):
		return load(path)
	else:
		var storyLine = StoryLine.new()
		return baseStoryLine.duplicate()
	
func saveStoryLine():
	var path:String = storyLineNameToSavePath(storyLineName)
	
	var dir = DirAccess.open("user://")
	if not(dir.dir_exists(GameManager.currentSaveDir)):
		dir.make_dir(GameManager.currentSaveDir)
		
	var error = ResourceSaver.save(self, path)
	assert(error == 0)

func getCurrentTimeline() -> DialogicTimeline:
	return timelines[currentTimelineIndex]
