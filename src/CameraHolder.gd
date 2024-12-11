extends Spatial

# Reference to the ball
onready var ball = get_node("../RigidBody")
onready var camera = $Camera

# Camera follow smoothing factor
var follow_speed = 5.0

# Mouse sensitivity and pitch limits
var sensitivity = 0.5
var min_pitch = -60.0
var max_pitch = 60.0

# Camera rotation variables
var yaw = 0.0
var pitch = 0.0

func _ready():
	# Hide the mouse cursor for free movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse motion for camera rotation
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, min_pitch, max_pitch)

func _process(delta):
	# Update the CameraHolder's position to follow the ball
	global_transform.origin = global_transform.origin.linear_interpolate(ball.global_transform.origin, follow_speed * delta)
	
	# Apply the yaw and pitch to the CameraHolder's rotation
	rotation_degrees = Vector3(pitch, yaw, 0)

