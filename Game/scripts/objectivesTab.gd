extends CanvasLayer
class_name ObjectivesTab

@export var objectives:Array[String] = []
@export var hiddenObjectives:Array[int] = []
@export var objectivesContainer:Control
@export var objectifPrefab:PackedScene
var objectifNodes:Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.objectivesTab = self
	for objectif in objectives:
		var label = objectifPrefab.instantiate()
		label.fit_content = true
		label.text = objectif
		objectifNodes.push_back(label)
		objectivesContainer.add_child(label)
		
	for idx in hiddenObjectives:
		objectifNodes[idx].visible = false
		
	await get_tree().process_frame
	if (GameManager.actionPointSystem != null):
		GameManager.actionPointSystem.onNoPoints.connect(func():
			hideObjectif(0)
			showObjectif(1)
			)

func hideObjectif(index:int):
	objectifNodes[index].visible = false

func showObjectif(index:int):
	objectifNodes[index].visible = true
