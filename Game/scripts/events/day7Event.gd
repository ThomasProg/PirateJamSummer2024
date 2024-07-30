extends Node

@export var bed:Bed
@export_file("*.tscn") var nextDayPathCorrect: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vote = Dialogic.VAR.vote
	match vote:
		"":
			print("no vote yet")
		"merchant":
			bed.nextDayPath = nextDayPathCorrect
			bed.rebind()
		
