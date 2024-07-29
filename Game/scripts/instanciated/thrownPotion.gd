extends Area3D
class_name ThrownPotion

#@export var particlesPrefab:PackedScene
@export var sprite:Sprite3D
@export var throwSound:AudioStream
var velocity:Vector3

var skillOwner = null

signal onExplode()

func playThrowSFX():
	var player = AudioStreamPlayer.new()
	player.stream = throwSound
	get_parent().add_child(player)
	player.play()
	player.finished.connect(func():
		player.queue_free())

func _ready() -> void:
	playThrowSFX()
	

func _on_body_entered(body):
	if (skillOwner == body):
		return
		
	onExplode.emit()
		
	queue_free()

func _physics_process(delta):
	global_position += velocity * delta
	
