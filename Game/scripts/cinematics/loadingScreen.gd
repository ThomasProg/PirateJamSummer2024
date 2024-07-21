extends Node
class_name LoadingScreen

@export var fadeInTime:float = 1.0
@export var fadeOutTime:float = 1.0
@export var minTimeOnScreen:float = 1.0
@export var content:CanvasItem

enum Mode {FadeIn, Visible, FadeOut}
var mode:Mode = Mode.FadeIn

signal onFadeInFinished
signal onFadeOutFinished

# Called when the node enters the scene tree for the first time.
func _ready():
	content.modulate = Color(1.0, 1.0, 1.0, 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match mode:
		Mode.FadeIn:
			content.modulate.a += delta / fadeInTime
			if (content.modulate.a >= 1.0):
				onFadeInFinished.emit()
				mode = Mode.Visible
	
		Mode.FadeOut:
			content.modulate.a -= delta / fadeOutTime
			if (content.modulate.a <= 0.0):
				onFadeOutFinished.emit()
				queue_free()
