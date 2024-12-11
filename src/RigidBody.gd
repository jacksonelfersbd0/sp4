extends RigidBody

# Speed and movement direction
var speed = 1.0
var direction = Vector3.ZERO

func _process(delta):
	direction = Vector3.ZERO

	# Keyboard Input
	if Input.is_action_pressed("ui_up"):
		direction += Vector3.FORWARD
	if Input.is_action_pressed("ui_down"):
		direction += Vector3.BACK
	if Input.is_action_pressed("ui_left"):
		direction += Vector3.LEFT
	if Input.is_action_pressed("ui_right"):
		direction += Vector3.RIGHT

	# Normalize and apply force
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		apply_central_impulse(direction * speed)


func _integrate_forces(state):
	# Gyroscope-based tilt (for mobile)
	if OS.has_feature("mobile"):
		var tilt = Input.get_accelerometer()  # Get accelerometer data
		apply_central_impulse(Vector3(-tilt.y, 0, -tilt.x) * speed)
