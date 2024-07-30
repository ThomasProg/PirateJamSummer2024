extends Node

@export var delaybeforeLose:float = 15.0
@export_file("*.tscn") var trueGameOverScreen: String
@export var gameOverScreen:PackedScene = preload("res://prefabs/cinematics/gameOverScreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(delaybeforeLose).timeout
	
	await GameManager.loadSceneWithLoadingScreen(trueGameOverScreen, gameOverScreen, null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
