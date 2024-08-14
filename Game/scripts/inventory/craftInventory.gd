extends Control
class_name CraftInventory

@export var availableRecipes:Array[CraftRecipe]
@export var currentRecipeIndex:int = 0

@export var slotPrefab:PackedScene
@export var craftInParent:Control
@export var craftOutTexture:TextureRect
@export var craftOutName:RichTextLabel
@export var craftOutDescription:RichTextLabel
@export var craftNextRecipeButton:BaseButton
@export var craftPreviousRecipeButton:BaseButton

@export var playerInv:PlayerInventory
@export var playerIngredientsContainer:Control
@export var playerPotionsContainer:Control

@export var craftButton:Button

@export var potionChangePlayer:AudioStreamPlayer

func getCurrentRecipe() -> CraftRecipe:
	return availableRecipes[currentRecipeIndex]

func onRecipeUpdated():
	var currentRecipe = getCurrentRecipe()
	craftOutTexture.texture = currentRecipe.result.texture
	craftOutName.text = currentRecipe.result.name
	craftOutDescription.text = currentRecipe.result.description
	
	for ingr in craftInParent.get_children():
		ingr.queue_free()
		
	for ingr in currentRecipe.ingredients:
		var slot = slotPrefab.instantiate() as InventorySlot
		slot.canBeDragged = false
		slot.dragGroup = 2
		slot.setItem(ingr)
		craftInParent.add_child(slot)
		
func updatePlayerInventory():
	if (playerInv == null):
		push_error("Player inv is null!")
		return null
	
	var ingredients = playerInv.ingredientInventory.items
	for i in range(ingredients.size()):
		var ingr = ingredients[i]
		var slot = playerIngredientsContainer.get_children()[i] as InventorySlot
		slot.setItem(ingr)
		for connection in slot.onItemSet.get_connections():
			slot.onItemSet.disconnect(connection.callable)
		slot.onItemSet.connect(func(newItem:InventoryItem):
			ingredients[i] = newItem
			)
		
	var potions = playerInv.potionInventory.items
	for i in range(potions.size()):
		var potion = potions[i]
		var slot = playerPotionsContainer.get_children()[i] as InventorySlot
		slot.setItem(potion)
		for connection in slot.onItemSet.get_connections():
			slot.onItemSet.disconnect(connection.callable)
		slot.onItemSet.connect(func(newItem:InventoryItem):
			potions[i] = newItem
			)

# Called when the node enters the scene tree for the first time.
func _ready():
	onRecipeUpdated()
	updatePlayerInventory()
	
	craftNextRecipeButton.pressed.connect(func():
		currentRecipeIndex = (currentRecipeIndex + 1) % availableRecipes.size()
		onRecipeUpdated()
		potionChangePlayer.play()
		)

	craftPreviousRecipeButton.pressed.connect(func():
		currentRecipeIndex = (currentRecipeIndex - 1 + availableRecipes.size()) % availableRecipes.size()
		onRecipeUpdated()
		potionChangePlayer.play()
		)

	craftButton.pressed.connect(func():
		var recipe = getCurrentRecipe()
		if (playerInv.ingredientInventory.tryConsumeItems(recipe.ingredients)):
			playerInv.giveItem(recipe.result)
			updatePlayerInventory()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
