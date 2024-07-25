extends PanelContainer
class_name InventorySlot

@export var draggedItemPrefab:PackedScene
@export var currentItem:InventoryItem
@export var tex:TextureRect
@export var tooltipPrefab:PackedScene
@export var dragGroup:int = 0
@export var canBeDragged:bool = true
var tooltip:Control
var isHovering

signal onItemSet(newItem:InventoryItem)

func _get_drag_data(at_position):
	if (currentItem == null):
		return null
	
	var preview = draggedItemPrefab.instantiate()
	preview.setItem(currentItem)
	preview.fromSlot = self
	preview.item = currentItem
	preview.dragGroup = dragGroup
	
	set_drag_preview(preview)
	setItem(null)
	
	return preview
	
	
func _can_drop_data(at_position, data):
	if (data is DraggedItem):
		return (currentItem == null) and (dragGroup == data.dragGroup)
		
	return false
	
func _drop_data(at_position, data):
	setItem(data.item)

func updateTooltipLocation():
	var mousePos = get_viewport().get_mouse_position() 
	var mouseOffset = Vector2(10, 10) + ProjectSettings.get_setting("display/mouse_cursor/tooltip_position_offset") 
	tooltip.global_position = mousePos + mouseOffset

func setItem(newItem:InventoryItem):
	currentItem = newItem
	if (newItem == null):
		tex.texture = null
	else:
		tex.texture = newItem.texture
		
	onItemSet.emit(newItem)

func _ready():
	setItem(currentItem)
	
	mouse_entered.connect(func():
		if (currentItem == null):
			return
			
		tooltip = tooltipPrefab.instantiate() as Control
		tooltip.nameLabel.text = currentItem.name
		tooltip.descriptionLabel.text = currentItem.description
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

#func _make_custom_tooltip(for_text):
	#if (currentItem == null):
		#return ""
		#
	#tooltip = tooltipPrefab.instantiate()
	#tooltip.nameLabel.text = currentItem.name
	#tooltip.descriptionLabel.text = currentItem.description
	#return tooltip
