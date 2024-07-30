extends Node

@export var currentScene:Node = null
@export var currentScenePath:String = ""
@export var dayLoadingScreen:PackedScene = preload("res://prefabs/cinematics/dayLoadingScreen.tscn")
@export var nightLoadingScreen:PackedScene = preload("res://prefabs/cinematics/nightLoadingScreen.tscn")
@export var gameOverScreen:PackedScene = preload("res://prefabs/cinematics/gameOverScreen.tscn")

@export var currentSaveDir = "save0"

# 0 = day 1
# 1 = night 1
# 2 = day 2
# 3 = night 2 
# etc
@export var saveKey:int = 0

@export var honey:InventoryIngredientItem = preload("res://inventoryAssets/ingredients/honeyIngr.tres")
@export var healingPotion:InventoryPotionItem = preload("res://inventoryAssets/potions/healingPotion.tres")


var isDay:bool = true
var player:Player
var objectivesTab:ObjectivesTab
var actionPointSystem:ActionPointSystem

func hideObjectif(idx:int):
	objectivesTab.hideObjectif(idx)
	
func showObjectif(idx:int):
	objectivesTab.showObjectif(idx)

func tryLoadAtKey(saveKey:int):
	var savePath = saveKeyToSavePath(saveKey)
	if DirAccess.dir_exists_absolute(savePath):
		loadInventories(savePath)
		return true
	return false
	
func saveAtCurrentKey():
	var savePath = saveKeyToSavePath(saveKey)
	saveInventories(savePath)
	
	
static func saveKeyToSavePath(dayNumber:int) -> String:
	return "user://%s/%d/" % [GameManager.currentSaveDir, dayNumber]
	
func saveInventories(path:String):		
	if not(DirAccess.dir_exists_absolute(path)):
		var err = DirAccess.make_dir_recursive_absolute(path)
		assert(err == 0)
		
	var inv = Utilities.findComponentByType(player, PlayerInventory)
		
	var error = ResourceSaver.save(inv.ingredientInventory, savePathToIngredientInventoryPath(path))
	assert(error == 0)
		
	var error2 = ResourceSaver.save(inv.potionInventory, savePathToPotionInventoryPath(path))
	assert(error2 == 0)
	
func savePathToIngredientInventoryPath(path:String):
	return path + "%s.res" % "ingredientsInventory"
	
func savePathToPotionInventoryPath(path:String):
	return path + "%s.res" % "potionsInventory"
	
func loadInventories(path:String):		
	var inv = Utilities.findComponentByType(player, PlayerInventory)
	inv.ingredientInventory = load(savePathToIngredientInventoryPath(path))
	inv.potionInventory = load(savePathToPotionInventoryPath(path))


func loadGameOver():
	var onLoaded = func(newScene):
		await get_tree().process_frame
		tryLoadAtKey(saveKey)
	await loadSceneWithLoadingScreen(currentScene.scene_file_path, gameOverScreen, onLoaded)
	#tryLoadAtKey(saveAtCurrentKey())

func loadNextDay(newScenePath:String):
	saveKey += 1
	saveAtCurrentKey()
	loadDay(newScenePath)
	
func loadNextNight(newScenePath:String, onNightLoaded):
	saveKey += 1
	saveAtCurrentKey()
	loadNight(newScenePath, onNightLoaded)

func loadDay(newScenePath:String):
	await loadSceneWithLoadingScreen(newScenePath, dayLoadingScreen)

func loadNight(newScenePath:String, onNightLoaded):
	saveKey += 1
	saveAtCurrentKey()
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

func giveHoney():
	var playerInv = Utilities.findComponentByType(player, PlayerInventory) as PlayerInventory
	playerInv.giveItem(honey)
	
func updateHasHealingPotion():
	var playerInv = Utilities.findComponentByType(player, PlayerInventory) as PlayerInventory
	var requiredItems:Array[InventoryItem] = [healingPotion]
	if(playerInv.potionInventory.canConsumeItems(requiredItems)):
		Dialogic.VAR.hasHealingPotion = true

var isConsumingDialogue:bool = true

func cancelDialogue():
	isConsumingDialogue = false
