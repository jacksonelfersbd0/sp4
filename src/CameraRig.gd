extends Spatial  # Can also extend Node

onready var ball = get_node("../Ball3")  # This accesses the Ball3 sibling node from CameraRig
onready var camera = $Camera  # Reference to the Camera

var offset = Vector3(0, 5, 10)  # Position of the camera relative to the ball
var smooth_factor = 2.0  # Smooth transition speed of the camera

var rotation_speed = 0.2  # Speed of camera rotation
var camera_yaw = 0  # Current yaw (rotation) of the camera
var pitch = 0  # Camera pitch (up and down rotation)
var pitch_limit = 80  # Limit for camera pitch (up and down rotation)

var last_mouse_position = Vector2.ZERO  # To store the last mouse position

func _ready():
	# Hide the cursor and capture it to control camera rotation
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Change to VISIBLE for debugging
	last_mouse_position = get_viewport().get_mouse_position()  # Store initial position of the mouse

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()  # Get current mouse position
	var mouse_delta = mouse_position - last_mouse_position  # Calculate mouse movement delta

	# Print mouse position for debugging
	print("Mouse Position: ", mouse_position)
	print("Mouse Delta: ", mouse_delta)

	# Update yaw and pitch
	camera_yaw -= mouse_delta.x * rotation_speed
	pitch -= mouse_delta.y * rotation_speed

	# Clamp the pitch to avoid flipping
	pitch = clamp(pitch, -pitch_limit, pitch_limit)

	# Rotate the camera based on yaw and pitch
	camera.rotation_degrees = Vector3(pitch, camera_yaw, 0)

	# Update the position of CameraRig to follow the ball smoothly
	var target_position = ball.global_transform.origin + offset
	global_transform.origin = global_transform.origin.linear_interpolate(target_position, delta * smooth_factor)

	# The camera always faces the ball (without rotating with the ball)
	camera.look_at(ball.global_transform.origin, Vector3.UP)

	# Player control for moving the ball based on camera direction
	var direction = Vector3.ZERO

	# Keyboard Input for forward/backward movement
	if Input.is_action_pressed("ui_up"):
		direction += camera.global_transform.basis.z  # Move forward in camera's local Z direction
	if Input.is_action_pressed("ui_down"):
		direction -= camera.global_transform.basis.z  # Move backward in camera's local Z direction

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		ball.apply_central_impulse(direction * 10)  # Adjust speed as needed

	# Update last mouse position
	last_mouse_position = mouse_position
