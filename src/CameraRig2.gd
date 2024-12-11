extends Spatial

onready var camera = $Camera  # Reference to the Camera node
var speed = 5.0  # Movement speed of the camera
var rotation_speed = 0.2  # Rotation speed of the camera

var mouse_sensitivity = 0.3  # How sensitive the mouse movement is
var yaw = 0  # Horizontal (yaw) rotation
var pitch = 0  # Vertical (pitch) rotation
var pitch_limit = 80  # Limit for vertical rotation to avoid flipping

var last_mouse_position = Vector2.ZERO  # To store the last mouse position

func _ready():
	# Hide the mouse cursor and capture it to control camera movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	last_mouse_position = get_viewport().get_mouse_position()

func _process(delta):
	# Get the current mouse position
	var mouse_position = get_viewport().get_mouse_position()
	
	# Print mouse position for debugging purposes
	print("Mouse Position: ", mouse_position)

	var mouse_delta = mouse_position - last_mouse_position  # Calculate mouse movement delta

	# Update yaw and pitch based on mouse delta
	yaw -= mouse_delta.x * rotation_speed * mouse_sensitivity
	pitch -= mouse_delta.y * rotation_speed * mouse_sensitivity

	# Clamp the pitch to prevent flipping
	pitch = clamp(pitch, -pitch_limit, pitch_limit)

	# Apply the rotation to the CameraRig
	rotation_degrees.y = yaw  # Yaw (horizontal rotation)

	# Update camera's pitch (vertical rotation) separately
	camera.rotation_degrees.x = pitch  # Pitch (vertical rotation)

	# Move the CameraRig using keyboard input (WASD for movement)
	var direction = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		direction += camera.global_transform.basis.z  # Move forward in the camera's direction
	if Input.is_action_pressed("ui_down"):
		direction -= camera.global_transform.basis.z  # Move backward
	if Input.is_action_pressed("ui_left"):
		direction -= camera.global_transform.basis.x  # Move left
	if Input.is_action_pressed("ui_right"):
		direction += camera.global_transform.basis.x  # Move right

	# Normalize the direction to ensure consistent speed and apply movement
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		global_transform.origin += direction * speed * delta  # Move the camera rig

	# Update the last mouse position
	last_mouse_position = mouse_position
