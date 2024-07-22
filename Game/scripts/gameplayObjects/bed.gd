extends Node

@export var interactable: Interactable
@export_file("*.tscn") var nextNightPath: String
@export_file("*.tscn") var nextDayPath: String

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.onInteracted.connect(func(player:Player):
		await GameManager.loadNight(nextNightPath)
		var night = Utilities.findComponentByType(GameManager.currentScene, NightEvent)
		if (night.nextDayPath.is_empty()):
			night.nextDayPath = nextDayPath 
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
