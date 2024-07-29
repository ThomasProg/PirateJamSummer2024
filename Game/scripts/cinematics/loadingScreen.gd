extends Node
class_name LoadingScreen

@export var fadeInTime:float = 1.0
@export var fadeOutTime:float = 1.0
@export var minTimeOnScreen:float = 1.0
@export var content:CanvasItem
@export var isItDayToNight: bool = true
@export var isItGameOver: bool = false

enum Mode {FadeIn, Visible, FadeOut}
var mode:Mode = Mode.FadeIn

signal onFadeInFinished
signal onFadeOutFinished

var fromSprite: Sprite2D
var toSprite: Sprite2D
var animationPlayer: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	content.modulate = Color(1.0, 1.0, 1.0, 0.0)
	fromSprite = $CanvasLayer/Panel/DayNightSpritesPanel/DayNightSpritesNode/FromSprite
	toSprite = $CanvasLayer/Panel/DayNightSpritesPanel/DayNightSpritesNode/ToSprite
	animationPlayer = $CanvasLayer/Panel/DayNightSpritesPanel/DayNightSpritesNode/AnimationPlayer
	toSprite.visible = false
	if isItGameOver:
		fromSprite.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match mode:
		Mode.FadeIn:
			content.modulate.a += delta / fadeInTime
			if (content.modulate.a >= 1.0):
				if !isItGameOver:
					dayNightAnimation()
				onFadeInFinished.emit()
				mode = Mode.Visible
	
		Mode.FadeOut:
			content.modulate.a -= delta / fadeOutTime
			if (content.modulate.a <= 0.0):
				onFadeOutFinished.emit()
				queue_free()

func dayNightAnimation():
	toSprite.visible = true
	animationPlayer.play("day_to_night_animation")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "day_to_night_animation":
		fromSprite.visible = false
