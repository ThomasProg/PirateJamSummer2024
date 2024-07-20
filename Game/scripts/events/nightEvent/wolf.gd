extends Sprite3D
class_name Wolf

@export var currentTargetPeekedTime:float = 0.0
@export var peekingDuration:float = 6.0
@export var maxTargetPeekedTime:float = 5.0
@export var target: CharacterBody3D
@export var eyeAnchors: Array[Node3D]
var raycasts:Array[RayCast3D]

signal onWolfWin()
signal onWolfAppears()
signal onWolfDisappears()

# Called when the node enters the scene tree for the first time.
func _ready():
	for eye in eyeAnchors:
		var raycast = RayCast3D.new()
		raycasts.push_back(raycast)
		get_parent().add_child.call_deferred(raycast)
		
	disappear()

func appear():
	currentTargetPeekedTime = 0
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
	
	var hasHitTarget:bool = false
	for i in range(eyeAnchors.size()):
		raycasts[i].global_position = eyeAnchors[i].global_position
		raycasts[i].target_position = target.global_position - raycasts[i].global_position

		var hit = raycasts[i].get_collider() as Node3D
		if (hit == target):
			hasHitTarget = true
			
			# Break for optimization if not in debug build
			# else, we would like to keep seeing all the raycasts follow the player for debug
			if not(OS.is_debug_build()):
				break
			
	if (hasHitTarget):
		currentTargetPeekedTime += delta
		
		print("Current time peeked: ", currentTargetPeekedTime)
		if currentTargetPeekedTime >= maxTargetPeekedTime:
			onWolfWin.emit()

	
	# billboard
	# Can't use the native feature since it doesn't lead to children
	# to update their transforms (we want the eyes to follow)
	var cameraPos = get_viewport().get_camera_3d().global_position
	cameraPos.y = global_position.y
	look_at(cameraPos, Vector3(0, 1, 0))
