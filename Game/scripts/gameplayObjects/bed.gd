extends CSGMesh3D

@export var interactable: Interactable
@export_file("*.tscn") var nextNightPath: String
@export_file("*.tscn") var nextDayPath: String

# The lambda used for the callback captures the context
# If put in the Node class directly, then it would have become invalid after the node gets destroyed
# By using a static function, we prevent that
static func bindInteractable(interactable, nextNightPath, nextDayPath):
	interactable.onInteracted.connect(func(player:Player):
		await GameManager.loadNextNight(nextNightPath, func(scene):
			var night = Utilities.findComponentByType(scene, NightEvent)
			if (night.nextDayPath.is_empty()):
				night.nextDayPath = nextDayPath 
			)
		)


# Called when the node enters the scene tree for the first time.
func _ready():
	bindInteractable(interactable, nextNightPath, nextDayPath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
