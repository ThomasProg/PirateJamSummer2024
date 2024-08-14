extends PanelContainer
class_name InventorySlot

@export var draggedItemPrefab:PackedScene
@export var currentStack:Stack
@export var tex:TextureRect
@export var countLabel:RichTextLabel
@export var tooltipPrefab:PackedScene
@export var dragGroup:int = 0
@export var canBeDragged:bool = true
var tooltip:Control
var isHovering

signal onItemSet(newStack:Stack)

func _get_drag_data(at_position):
	if (currentStack == null):
		return null
	
	var preview = draggedItemPrefab.instantiate()
	preview.setStack(currentStack)
	preview.fromSlot = self
	preview.stack = currentStack
	preview.dragGroup = dragGroup
	
	set_drag_preview(preview)
	setStack(null)
	
	return preview
	
	
func _can_drop_data(at_position, data):
	if (data is DraggedItem):
		return (currentStack == null) and (dragGroup == data.dragGroup)
		
	return false
	
func _drop_data(at_position, data):
	setStack(data.stack)

func updateTooltipLocation():
	var mousePos = get_viewport().get_mouse_position() 
	var mouseOffset = Vector2(10, 10) + ProjectSettings.get_setting("display/mouse_cursor/tooltip_position_offset") 
	tooltip.global_position = mousePos + mouseOffset
	
func setStack(newStack:Stack):
	currentStack = newStack
	if (newStack == null):
		tex.texture = null
		countLabel.visible = false
	else:
		tex.texture = newStack.item.texture
		countLabel.visible = true
		countLabel.text = str(newStack.count)
		
	onItemSet.emit(newStack)

func _ready():
	setStack(currentStack)
	
	mouse_entered.connect(func():
		if (currentStack == null):
			return
			
		tooltip = tooltipPrefab.instantiate() as Control
		tooltip.nameLabel.text = currentStack.item.name
		tooltip.descriptionLabel.text = currentStack.item.description
		var p = get_parent()
		while not(p is CanvasLayer):
			p = p.get_parent()
		
		p.add_child(tooltip)
		updateTooltipLocation()
		
		)
		
	mouse_exited.connect(func():
		if (tooltip != null):
			tooltip.queue_free()
			tooltip = null
		)

func _process(delta):
	if tooltip != null:
		updateTooltipLocation()
