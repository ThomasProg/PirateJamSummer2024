extends Node

@export var currentScene:Node = null
@export var currentScenePath:String = ""
@export var dayLoadingScreen:PackedScene = preload("res://prefabs/cinematics/dayLoadingScreen.tscn")
@export var nightLoadingScreen:PackedScene = preload("res://prefabs/cinematics/nightLoadingScreen.tscn")
@export var gameOverScreen:PackedScene = preload("res://prefabs/cinematics/gameOverScreen.tscn")

func loadGameOver():
	await loadSceneWithLoadingScreen(currentScenePath, gameOverScreen)

func loadDay(newScenePath:String):
	await loadSceneWithLoadingScreen(newScenePath, dayLoadingScreen)

func loadNight(newScenePath:String, onNightLoaded):
	await loadSceneWithLoadingScreen(newScenePath, nightLoadingScreen, onNightLoaded)

func loadSceneWithLoadingScreen(newScenePath:String, loadingScreenPrefab:PackedScene, onSceneLoaded = null):
	var loadingScreen = loadingScreenPrefab.instantiate() as LoadingScreen
	get_parent().add_child(loadingScreen)
	
	ResourceLoader.load_threaded_request(newScenePath)
	
	await loadingScreen.onFadeInFinished
	
	if (currentScene != null):
		currentScene.queue_free()
		currentScene = null
	
	await get_tree().create_timer(loadingScreen.minTimeOnScreen).timeout
	
	var loadStatus = ResourceLoader.load_threaded_get_status(newScenePath)
	while loadStatus != ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame
		loadStatus = ResourceLoader.load_threaded_get_status(newScenePath)
		
	currentScenePath = newScenePath
	currentScene = (ResourceLoader.load_threaded_get(newScenePath) as PackedScene).instantiate()
	if (onSceneLoaded != null):
		onSceneLoaded.call(currentScene)
	get_parent().add_child(currentScene)
	loadingScreen.mode = LoadingScreen.Mode.FadeOut 

func loadNewScene(newScenePath:String):
	if (currentScene != null):
		currentScene.queue_free()
		currentScene = null
		
	ResourceLoader.load_threaded_request(newScenePath)
	
	
	var loadStatus =  ResourceLoader.load_threaded_get_status(newScenePath)
	currentScene = (ResourceLoader.load_threaded_get(newScenePath) as PackedScene).instantiate()
	get_parent().add_child(currentScene)

func _ready():
	currentScene = Utilities.findComponentByType(get_parent(), Node3D)
