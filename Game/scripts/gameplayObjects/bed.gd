extends Area3D
class_name Bed

@export var interactable: Interactable
@export_file("*.tscn") var nextNightPath: String
@export_file("*.tscn") var nextDayPath: String
@export var enabled:bool = true

# The lambda used for the callback captures the context
# If put in the Node class directly, then it would have become invalid after the node gets destroyed
# By using a static function, we prevent that
static func bindInteractable(interactable:Interactable, nextNightPath, nextDayPath):
	interactable.onInteracted.connect(func(player:Player):
		interactable.queue_free()
		await GameManager.loadNextNight(nextNightPath, func(scene):
			var night = Utilities.findComponentByType(scene, NightEvent)
			if (night.nextDayPath.is_empty()):
				night.nextDayPath = nextDayPath 
			)
		)

func _input(event: InputEvent) -> void:
	if (Input.is_action_pressed("SkipNight")):
		if (interactable != null):
			interactable.onInteracted.emit(GameManager.player)
			interactable = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if (enabled):
		bindInteractable(interactable, nextNightPath, nextDayPath)

func unbindInteractableAll():
	if (interactable != null):
		for connection in interactable.onInteracted.get_connections():
			interactable.onInteracted.disconnect(connection.callable)

func rebind():
	unbindInteractableAll()
	if (interactable != null):
		bindInteractable(interactable, nextNightPath, nextDayPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
