extends Panel
class_name InventorySlot

@export var currentItem:InventoryItem
@export var tex:TextureRect
@export var tooltipPrefab:PackedScene
var tooltip:Control
var isHovering

func _get_drag_data(at_position):
	var previewTex = TextureRect.new()
	previewTex.texture = tex.texture
	previewTex.expand_mode = 1
	previewTex.size = tex.size
	
	var preview = Control.new()
	preview.add_child(previewTex)
	
	set_drag_preview(preview)
	tex.texture = null
	
	return previewTex.texture
	
	
func _can_drop_data(at_position, data):
	return data is Texture2D
	
func _drop_data(at_position, data):
	tex.texture = data

func updateTooltipLocation():
	var mousePos = get_viewport().get_mouse_position() 
	var mouseOffset = Vector2(10, 10) + ProjectSettings.get_setting("display/mouse_cursor/tooltip_position_offset") 
	tooltip.global_position = mousePos + mouseOffset

func _ready():
	mouse_entered.connect(func():
		if (currentItem == null):
			return
			
		tooltip = tooltipPrefab.instantiate() as Control
		tooltip.nameLabel.text = currentItem.name
		tooltip.descriptionLabel.text = currentItem.description
		get_tree().root.add_child(tooltip)
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
