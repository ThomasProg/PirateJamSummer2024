extends Node3D
class_name PotionEffect

@export var particlesPrefab:PackedScene = preload("res://prefabs/instanced/potionParticles.tscn")
var particles:GPUParticles3D = null
var skillOwner:Player

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
	spawnParticles()
	queue_free()
