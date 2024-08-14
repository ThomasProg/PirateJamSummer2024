extends Node
class_name LoadingScreen

@export var fadeInTime:float = 1.0
@export var fadeOutTime:float = 1.0
@export var minTimeOnScreen:float = 1.0
@export var content:CanvasItem
@export var isItDayToNight: bool = true

@export var isItGameOver: bool = false
var gameOverAnimFinished: bool = false
var bloodSprites1: Node2D
var bloodSprites2: Node2D

enum Mode {FadeIn, Visible, FadeOut}
var mode:Mode = Mode.FadeIn

signal onFadeInFinished
signal onFadeOutFinished

var fromSprite: Sprite2D
var toSprite: Sprite2D
var animationPlayer: AnimationPlayer

@export var sfx: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loading screen loaded")
	content.modulate = Color(1.0, 1.0, 1.0, 0.0)
	fromSprite = $CanvasLayer/Panel/DayNightSpritesPanel/DayNightSpritesNode/FromSprite
	toSprite = $CanvasLayer/Panel/DayNightSpritesPanel/DayNightSpritesNode/ToSprite
	animationPlayer = $CanvasLayer/Panel/DayNightSpritesPanel/DayNightSpritesNode/AnimationPlayer
	toSprite.visible = false
	if isItGameOver:
		fromSprite.visible = false
		bloodSprites1 = $CanvasLayer/GameOverPanel/GameOverSprites2/BloodSpritesNode01
		bloodSprites2 = $CanvasLayer/GameOverPanel/GameOverSprites2/BloodSpritesNode02
		gameOverAnimation()
	
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = sfx
	get_parent().add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(func():
		audioPlayer.queue_free())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isItGameOver or gameOverAnimFinished:
		match mode:
			Mode.FadeIn:
				content.modulate.a += delta / fadeInTime
				if (content.modulate.a >= 1.0):
					if !isItGameOver:
						dayNightAnimation()
					onFadeInFinished.emit()
					print("onFadeInFinished")
					mode = Mode.Visible
		
			Mode.FadeOut:
				content.modulate.a -= delta / fadeOutTime
				if (content.modulate.a <= 0.0):
					onFadeOutFinished.emit()
					queue_free()

func dayNightAnimation():
	#$CanvasLayer/Panel/BlackSprite.visible = true
	toSprite.visible = true
	animationPlayer.play("day_to_night_animation")
	
func gameOverAnimation():
	#animationPlayer.play("game_over_animation")
	bloodSprites1.visible = false
	bloodSprites2.visible = false
	runGameOverAnim()
	await get_tree().create_timer(0.25).timeout
	bloodSprites1.position = get_viewport().size / 2.0
	bloodSprites1.visible = true
	await get_tree().create_timer(0.35).timeout
	bloodSprites2.position = get_viewport().size / 2.0
	bloodSprites2.visible = true
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "day_to_night_animation":
		fromSprite.visible = false
		#$CanvasLayer/Panel/BlackSprite.visible = false
	if anim_name == "game_over_animation":
		gameOverAnimFinished = true
		
func runGameOverAnim():
	var top = $CanvasLayer/GameOverPanel/GameOverSprites2/Top as Control
	var bot = $CanvasLayer/GameOverPanel/GameOverSprites2/Bottom as Control
	var viewport = get_viewport()
	
	top.position.y = 0
	bot.position.y = 0
	top.size.y = viewport.size.y 
	bot.size.y = viewport.size.y 
	#return
	
	top.position.y = -690.0/1080.0 * viewport.size.y
	bot.position.y = 690.0/1080.0 * viewport.size.y + viewport.size.y /2.0
	
	print(bot.position.y)

	var topTween = get_tree().create_tween()
	topTween.tween_property(top, "position", Vector2.ZERO, 0.1)
	topTween.tween_callback(func():
		var topTween2 = get_tree().create_tween()
		#topTween2.set_trans(Tween.TRANS_SINE)
		topTween2.tween_property(top, "position", Vector2(0, -150.0/1080.0 * viewport.size.y), 0.2)
		topTween2.tween_callback(func():
			var topTween3 = get_tree().create_tween()
			#topTween3.set_trans(Tween.TRANS_SINE)
			topTween3.tween_property(top, "position", Vector2.ZERO, 0.2)
			).set_delay(0.0)
		).set_delay(0.1)
	
	var botTween = get_tree().create_tween()
	botTween.tween_property(bot, "position", Vector2.ZERO, 0.1)
	botTween.tween_callback(func():
		var botTween2 = get_tree().create_tween()
		#botTween2.set_trans(Tween.TRANS_SINE)
		botTween2.tween_property(bot, "position", Vector2(0, 150.0/1080.0 * viewport.size.y), 0.2)
		botTween2.tween_callback(func():
			var botTween3 = get_tree().create_tween()
			#botTween3.set_trans(Tween.TRANS_SINE)
			botTween3.tween_property(bot, "position", Vector2.ZERO, 0.2)
			).set_delay(0.0)
		).set_delay(0.1)
