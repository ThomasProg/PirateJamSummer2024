extends Node

@export var interactable: Interactable
@export_file("*.tscn") var nextNightPath: String

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.onInteracted.connect(func(player:Player):
		GameManager.loadNight(nextNightPath)
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
