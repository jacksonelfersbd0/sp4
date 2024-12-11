extends Spatial

# Mouse sensitivity and limits for rotation
var sensitivity = 0.5
var min_pitch = -45.0
var max_pitch = 45.0

# Yaw and pitch values for the camera
var yaw = 0.0
var pitch = 0.0

# Reference to the camera
onready var camera = $CameraHolder/Camera

func _ready():
	# Hide the mouse cursor for free movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Check if the event is a mouse motion event
	if event is InputEventMouseMotion:
		# Get the mouse delta
		var mouse_delta = event.relative
		
		# Rotate based on mouse delta
		yaw -= mouse_delta.x * sensitivity
		pitch -= mouse_delta.y * sensitivity
		
		# Clamp pitch to avoid flipping
		pitch = clamp(pitch, min_pitch, max_pitch)
		
		# Apply rotation to the camera holder
		rotation_degrees = Vector3(pitch, yaw, 0)
