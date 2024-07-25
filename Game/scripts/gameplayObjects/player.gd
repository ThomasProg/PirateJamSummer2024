extends CharacterBody3D
class_name Player

@export var camera:Camera3D
@export var collider:CollisionShape3D
@export var mouseSensitivity = 0.002

@export var speed:float = 5.0
@export var sprintSpeed:float = 15.0
@export var jumpVelocity:float = 4.5
@export var invertMouseY:bool = false;

@export var enableTestRayCast:bool = false

@export var ingameMenu:Control

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var captureMouse = false
var blockMouseCapture = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _input(event: InputEvent):
	if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		if event is InputEventMouseMotion and captureMouse:
			var eventRelativeY = event.relative.y if invertMouseY else -event.relative.y
			rotate_y(-event.relative.x * mouseSensitivity)
			camera.rotate_x(eventRelativeY * mouseSensitivity)
			camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
			
	if event is InputEventMouseButton:
		if not captureMouse and not(blockMouseCapture):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			captureMouse = true
			Engine.time_scale = 1.0
		
	if event is InputEventKey:
		if Input.is_action_just_pressed("OpenMenu"):
			if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				ingameMenu.updatePlayerInventory()
				ingameMenu.visible = true
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
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
		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if (Input.mouse_mode != Input.MOUSE_MODE_CAPTURED):
		move_and_slide()
		return

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpVelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var usedSpeed = sprintSpeed if Input.is_action_pressed("Sprint") else speed
	if direction:
		velocity.x = direction.x * usedSpeed
		velocity.z = direction.z * usedSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, usedSpeed)
		velocity.z = move_toward(velocity.z, 0, usedSpeed)

	move_and_slide()

		
