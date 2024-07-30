extends Node

@export var werewolfDialogue:SharedDialogue
@export var bed:Bed

@export_file("*.tscn") var nextNightPathIfTalkedToWerewolf: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	werewolfDialogue.onStarted.connect(func(characterTalkedTo:Character, player:Player):
		bed.nextNightPath = nextNightPathIfTalkedToWerewolf
		bed.rebind()
		)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
