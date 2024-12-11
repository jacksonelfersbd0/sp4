extends RigidBody

# Movement speed
var speed = 10.0
var rotation_sense = 1.0 # Adjust to reverse direction if needed

# Reference to the camera and its holder
onready var camera_holder = $CameraHolder
onready var camera = camera_holder.get_node("Camera")

# Vector to move the ball
var velocity = Vector3()

#func _ready():
	# Set the rigid body mode to "Character" to simulate a more controlled ball movement
	#mode = RigidBody.MODE_KINEMATIC

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

	# Apply movement using forces
	add_force(move_dir.normalized() * speed, Vector3.ZERO)

