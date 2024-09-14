extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var rotation_speed: float = 5.0

# Force applied to the ball when colliding
var kick_force = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		rotate_towards(direction, delta)
		velocity = transform.basis.z * -SPEED
	#else:
		#velocity= move_toward(velocity.x, 0, SPEED)
		#velocity = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func rotate_towards(direction: Vector3, delta):
	# Get the forward direction of the character (local Z axis in Godot 3D is forward)
	var forward_direction = -transform.basis.z

	# Calculate the angle between the forward direction and the input direction
	var angle_to_target = forward_direction.angle_to(direction)

	# Calculate the rotation direction (sign) and apply the rotation
	var rotation_direction = forward_direction.cross(direction).y # Positive or negative rotation

	# Rotate the character based on the angle, rotation speed, and direction
	rotation.y += rotation_direction * min(angle_to_target, rotation_speed * delta)


