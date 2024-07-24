extends Node
class_name RichTextLabelReplacer

@export var label: RichTextLabel

var previousText = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (label.text != previousText):
		var priest = "[color=red][outline_size=2][outline_color=dark_red][wave amp=10.0 freq=5.0 connected=1]"
		var endpriest = "[/wave][/outline_color][/outline_size][/color]"
		label.text = label.text.replace("[Priest]", priest)
		label.text = label.text.replace("[/Priest]", endpriest)
		previousText = label.text
