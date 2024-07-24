extends Node

@export var currentScene:Node = null
@export var currentScenePath:String = ""
@export var dayLoadingScreen:PackedScene = preload("res://prefabs/cinematics/dayLoadingScreen.tscn")
@export var nightLoadingScreen:PackedScene = preload("res://prefabs/cinematics/nightLoadingScreen.tscn")
@export var gameOverScreen:PackedScene = preload("res://prefabs/cinematics/gameOverScreen.tscn")

@export var currentSaveDir = "save0"

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

	# Start a new game
	print("===== starting new game =====")
	var saveGamePath = "user://%s/" % currentSaveDir

	var dir = DirAccess.open(saveGamePath)
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if dir.current_is_dir():
				print("Found directory: " + filename)
				# TODO : recursive
			else:
				print("Found file: " + filename)
				DirAccess.remove_absolute(saveGamePath + filename)
			filename = dir.get_next()

	DirAccess.remove_absolute(saveGamePath)
