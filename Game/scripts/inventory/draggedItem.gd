extends Control
class_name DraggedItem

@export var tex:TextureRect
@export var stack:Stack = null
@export var fromSlot:InventorySlot
@export var dragGroup:int

func setStack(stack:Stack):
	tex.texture = stack.item.texture

func _exit_tree():
	if (!get_viewport().gui_is_drag_successful()):
		fromSlot.setStack(stack)
