extends Node3D
class_name PotionEffect

@export var particlesPrefab:PackedScene = preload("res://prefabs/instanced/potionParticles.tscn")
@export var potionUseSFX:AudioStream
var particles:GPUParticles3D = null
var skillOwner:Player

# Static to keep lambda
static func playUseSFX(sfx:AudioStream, parent:Node):
	var player = AudioStreamPlayer.new()
	player.stream = sfx
	parent.get_parent().add_child(player)
	player.play()
	player.finished.connect(func():
		player.queue_free())

func setParticleColor(newColor:Color):
	var mat = particles.process_material
	if mat is ParticleProcessMaterial:
		mat.color = newColor

func spawnParticles():
	particles = particlesPrefab.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.emitting = true
	
# Called when the node enters the scene tree for the first time.
func runEffect():
	playUseSFX(potionUseSFX, skillOwner)
	spawnParticles()
	queue_free()
