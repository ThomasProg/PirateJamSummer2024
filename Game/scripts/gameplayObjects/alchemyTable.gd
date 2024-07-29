extends Area3D
class_name AlchemyTable

@export var redPotionInteractible:Interactable
@export var yellowPotionInteractible:Interactable
@export var redPotion:InventoryItem
@export var yellowPotion:InventoryItem
@export var timeForPotion:float = 10.0
@export var currentProgress:float = 0.0

var player:Player = null

var selectedInteractible:Interactable = null
var interactor:AlchemyTableInteractor = null

signal onPotionPrepared()

func addProgress(progress:float):
	if (currentProgress < timeForPotion):
		currentProgress += progress
		if (currentProgress >= timeForPotion):
			onPotionPrepared.emit()

func _ready():
	redPotionInteractible.onInteracted.connect(func(player:Player):
		selectedInteractible = redPotionInteractible
		currentProgress = 0.0
		)
		
	yellowPotionInteractible.onInteracted.connect(func(player:Player):
		selectedInteractible = yellowPotionInteractible
		currentProgress = 0.0
		)
		
	onPotionPrepared.connect(func():
		var potionSelector = Utilities.findComponentByType(player, PotionSelector)
		if (potionSelector != null):
			var potion = null
			match selectedInteractible:
				redPotionInteractible:
					potion = redPotion
				yellowPotionInteractible:
					potion = yellowPotion						
			var index = potionSelector.playerInv.potionInventory.addItem(potion)
			if (index != -1):
				potionSelector.selectItemAtIndex(index)
					
		selectedInteractible = null
		)

func _on_body_entered(body):
	if body is Player:
		player = body
		interactor = Utilities.findComponentByType(body, AlchemyTableInteractor)
		if (interactor != null):
			interactor.onAreaEntered(self)


func _on_body_exited(body):
	if body is Player:
		if (body == player):
			player = null

		var tableInteractor = Utilities.findComponentByType(body, AlchemyTableInteractor)
		if (tableInteractor != null):
			tableInteractor.onAreaExited(self)

	interactor = null
