extends Area3D
class_name Wolf

enum EyeColor{RED, YELLOW}

@export var sprite:Sprite3D
@export var aggroProgressBar:ProgressBar
@export var peekingDuration:float = 6.0
@export var target: Player
@export var eyeAnchors: Array[Node3D]
@export var lookAt:Node3D
@export var eyeColor:EyeColor = EyeColor.RED

@export var maxAggro:float = 20.0
@export var aggro:float = 2.0
@export var currentPeekAggro:float = 0.0

@export var aggroMultWhenPeeking:float = 1.0
@export var currentPeekAggroMult:float = 2.0

var raycasts:Array[RayCast3D]

signal onWolfWin()
signal onWolfAppears()
signal onWolfDisappears()
	
func getTotalAggro():
	return aggro + currentPeekAggro
	
func onAggroUpdated():
	aggroProgressBar.value = getTotalAggro()
	aggroProgressBar.max_value = maxAggro
	
	if (getTotalAggro() > maxAggro):
		onWolfWin.emit()

func setRandomEyeColor():
	eyeColor = EyeColor.values()[randi()%EyeColor.size() ]
	match eyeColor:
		EyeColor.RED:
			sprite.modulate = Color.DARK_RED
		EyeColor.YELLOW:
			sprite.modulate = Color.YELLOW
	
# Called when the node enters the scene tree for the first time.
func _ready():
	setRandomEyeColor()
	onAggroUpdated()
	for eye in eyeAnchors:
		var raycast = RayCast3D.new()
		raycasts.push_back(raycast)
		get_parent().add_child.call_deferred(raycast)
		
	disappear()

func appear():
	currentPeekAggro = 0.0
		
	visible = true
	for raycast in raycasts:
		raycast.enabled = true
		
	onWolfAppears.emit()	
		
	await get_tree().create_timer(peekingDuration).timeout
	disappear()

func disappear():
	visible = false
	for raycast in raycasts:
		raycast.enabled = false
		
	onWolfDisappears.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not(visible):
		return
	
	# peeks
	var hasHitTarget:bool = false
	for i in range(eyeAnchors.size()):
		raycasts[i].global_position = eyeAnchors[i].global_position
		
		var globalTargetPos:Vector3 = target.global_position
		var capsule = target.collider.shape as CapsuleShape3D
		if (capsule != null):
			var min = globalTargetPos.y - capsule.height / 2.0
			var max = globalTargetPos.y + capsule.height / 2.0
			globalTargetPos.y = clampf(raycasts[i].global_position.y, min, max)
		
		raycasts[i].target_position = globalTargetPos - raycasts[i].global_position
		
		var hit = raycasts[i].get_collider() as Node3D
		
		if (hit == target):
			hasHitTarget = true
			
			# Break for optimization if not in debug build
			# else, we would like to keep seeing all the raycasts follow the player for debug
			if not(OS.is_debug_build()):
				break
			
	if (hasHitTarget):
		# TODO : curve ?
		currentPeekAggro += delta * currentPeekAggroMult
		aggro += delta * aggroMultWhenPeeking
		onAggroUpdated()
	
	# billboard
	# Can't use the native feature since it doesn't lead to children
	# to update their transforms (we want the eyes to follow)
	var posToLookAt = lookAt.global_position #get_viewport().get_camera_3d().global_position
	posToLookAt.y = global_position.y
	look_at(posToLookAt, Vector3(0, 1, 0))
