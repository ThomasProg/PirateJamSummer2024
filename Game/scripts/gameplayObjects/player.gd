extends CharacterBody3D

@export var camera:Camera3D
@export var mouseSensitivity = 0.002

@export var speed = 5.0
@export var jumpVelocity = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event):
	print(Input.mouse_mode)
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouseSensitivity)
		camera.rotate_x(-event.relative.y * mouseSensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
	if event is InputEventKey:
		if Input.is_action_just_pressed("OpenMenu"):
			if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpVelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
