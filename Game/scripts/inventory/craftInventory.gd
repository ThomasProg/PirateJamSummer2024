extends Control
class_name CraftInventory

@export var availableRecipes:Array[CraftRecipe]
@export var currentRecipeIndex:int = 0

@export var slotPrefab:PackedScene
@export var craftInParent:Control
@export var craftOutName:RichTextLabel
@export var craftOutDescription:RichTextLabel
@export var craftNextRecipeButton:Button
@export var craftPreviousRecipeButton:Button

func getCurrentRecipe() -> CraftRecipe:
	return availableRecipes[currentRecipeIndex]

func onRecipeUpdated():
	var currentRecipe = getCurrentRecipe()
	craftOutName.text = currentRecipe.result.name
	craftOutDescription.text = currentRecipe.result.description
	
	for ingr in craftInParent.get_children():
		ingr.queue_free()
		
	for ingr in currentRecipe.ingredients:
		var slot = slotPrefab.instantiate() as InventorySlot
		slot.tex.texture = ingr.texture
		craftInParent.add_child(slot)
		
	

# Called when the node enters the scene tree for the first time.
func _ready():
	craftNextRecipeButton.pressed.connect(func():
		currentRecipeIndex = (currentRecipeIndex + 1) % availableRecipes.size()
		onRecipeUpdated()
		)

	craftPreviousRecipeButton.pressed.connect(func():
		currentRecipeIndex = (currentRecipeIndex - 1 + availableRecipes.size()) % availableRecipes.size()
		onRecipeUpdated()
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
