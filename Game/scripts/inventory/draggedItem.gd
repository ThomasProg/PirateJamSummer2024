extends Control
class_name DraggedItem

@export var tex:TextureRect
@export var item:InventoryItem = null
@export var fromSlot:InventorySlot
@export var dragGroup:int

func setItem(item:InventoryItem):
	tex.texture = item.texture

func _exit_tree():
	if (!get_viewport().gui_is_drag_successful()):
		fromSlot.setItem(item)
