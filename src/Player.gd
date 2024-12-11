extends RigidBody

# Movement speed
var speed = 40.0

# Reference to the camera and its holder
onready var camera_holder = get_node("../CameraHolder")
onready var camera = camera_holder.get_node("Camera")

# Vector to move the ball
var velocity = Vector3()

func _process(delta):
	# Get the camera's forward direction and right direction
	var forward = -camera.global_transform.basis.z.normalized()  # Negative Z is forward
	var right = camera.global_transform.basis.x.normalized()    # X is right

	# Get input from the player
	var move_dir = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		move_dir += forward
	if Input.is_action_pressed("ui_down"):
		move_dir -= forward
	if Input.is_action_pressed("ui_left"):
		move_dir -= right
	if Input.is_action_pressed("ui_right"):
		move_dir += right

	# Add forward movement if the left mouse button is held
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		move_dir += forward

	# Apply movement using forces
	if move_dir != Vector3.ZERO:
		add_force(move_dir.normalized() * speed, Vector3.ZERO)
