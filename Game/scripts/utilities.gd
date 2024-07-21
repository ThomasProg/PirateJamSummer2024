class_name Utilities

static func findComponentByType(parent, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
