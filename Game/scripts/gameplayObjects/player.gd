extends CharacterBody3D
class_name Player

@export var camera:Camera3D
@export var collider:CollisionShape3D
@export var mouseSensitivity:float = 0.002

@export var speed:float = 5.0
@export var sprintSpeed:float = 15.0
@export var jumpVelocity:float = 4.5
@export var invertMouseY:bool = false;

@export var enableTestRayCast:bool = false

@export var ingameMenu:Control

@export var mouseSensibility:float = 0.32
@export var audioStreamPlayerStep:AudioStreamPlayer
@export var stepOnDirtSFX:Array[AudioStream]
@export var stepOnWoodSFX:Array[AudioStream]

@export var isOnDirt:bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var captureMouse = false
var blockMouseCapture = false

@export var invisibilityEffect:Control
var nbInvisibleEffects = 0
func updateInvisibility():
	if nbInvisibleEffects == 0:
		invisibilityEffect.visible = false
	else:
		invisibilityEffect.visible = true

func _ready():
	GameManager.player = self
	captureMouse = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
var rotInput:float = 0.0
var tiltInput:float = 0.0
var mouseRot:Vector3
var playerRot:Vector3
var cameraRot:Vector3

func updateCamera(delta:float):
	mouseRot.x += tiltInput * delta
	mouseRot.x = clamp(mouseRot.x, deg_to_rad(-90), deg_to_rad(90))
	mouseRot.y += rotInput * delta
	
	playerRot = Vector3(0.0, mouseRot.y, 0.0)
	cameraRot = Vector3(mouseRot.x, 0.0, 0.0)
	
	camera.transform.basis = Basis.from_euler(cameraRot)
	camera.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(playerRot)
	
	rotInput = 0.0
	tiltInput = 0.0
	
func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion) and captureMouse:
		rotInput = -event.relative.x * mouseSensibility
		tiltInput = -event.relative.y * mouseSensibility
	
func _input(event: InputEvent):
	#if (captureMouse):
		#if event is InputEventMouseMotion:
			#var eventRelativeY = event.relative.y if invertMouseY else -event.relative.y
			#rotate_y(-event.relative.x * mouseSensitivity)
			#camera.rotate_x(eventRelativeY * mouseSensitivity)
			##camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
			#mouseMotion += -event.relative*0.00015*DPI
			
	if event is InputEventMouseButton:
		#if not captureMouse and not(blockMouseCapture):
		if (captureMouse):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventKey:
		if Input.is_action_just_pressed("OpenMenu"):
			if (captureMouse):
				captureMouse = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				ingameMenu.updatePlayerInventory()
				ingameMenu.visible = true
			else:
				captureMouse = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				ingameMenu.visible = false
			
	if Input.is_action_just_pressed("InvertMouseYAxis"):
		invertMouseY = not(invertMouseY)
			
	if Input.is_action_just_pressed("Interact") and captureMouse:
		if (OS.is_debug_build() and enableTestRayCast):
			var raycast = RayCast3D.new()
			get_parent().add_child(raycast)
			raycast.name = "TestRay"
			raycast.global_position = camera.global_position
			raycast.target_position = -camera.get_global_transform().basis.z * 2
			raycast.force_raycast_update()

			if (raycast.is_colliding()):
				print(raycast.get_collider())
			else:
				print("Nothing interacted with")
		

var lastStepTime:float = 0

func _physics_process(delta):
	updateCamera(delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if not(captureMouse):
		velocity = Vector3(0, velocity.y, 0)
		move_and_slide()
		return

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = jumpVelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var usedSpeed = sprintSpeed if Input.is_action_pressed("Sprint") else speed
	if direction:
		velocity.x = direction.x * usedSpeed
		velocity.z = direction.z * usedSpeed
		
		var currentMoveTime = Time.get_ticks_usec()
		
		var stepDelay:float
		if (Input.is_action_pressed("Sprint")):
			stepDelay = 0.2*1000*1000
		else:
			stepDelay = 0.4 * 1000 * 1000

			
		if (currentMoveTime - lastStepTime > stepDelay):
			#var space_state = get_world_3d().direct_space_state
			#var cam = $Camera3D
			#var mousepos = get_viewport().get_mouse_position()
#
			#var origin = self.global_position
			#var end = origin - Vector3.DOWN * 3
			#var query = PhysicsRayQueryParameters3D.create(origin, end)
			#query.collide_with_areas = true
#
			#var result = space_state.intersect_ray(query)
			#print(result)
			if (isOnDirt):
				audioStreamPlayerStep.stream = stepOnDirtSFX.pick_random()
			else:
				audioStreamPlayerStep.stream = stepOnWoodSFX.pick_random()
			audioStreamPlayerStep.play()
			lastStepTime = Time.get_ticks_usec()
			
		
	else:
		velocity.x = move_toward(velocity.x, 0, usedSpeed)
		velocity.z = move_toward(velocity.z, 0, usedSpeed)

	move_and_slide()

		
