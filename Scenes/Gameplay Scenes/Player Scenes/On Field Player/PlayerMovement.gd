extends Node3D
## This script deals with player movement. Works for both User Controlled and AI players. 
##
## 

""" Constants """
# Following are in KM/H or Kilometers per hour
const MAX_SPRINT_SPEED: float = 44.0
const MIN_SPRINT_SPEED: float = 30.0 



## Reference to the player instance
@onready var player_body: CharacterBody3D = get_owner();


# Movement and rotation speeds
var move_speed : float = 1000.0
var rotation_speed : float = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not player_body.is_on_floor():
		player_body.velocity =  Vector3(0, -100, 0)
		player_body.move_and_slide()
		return
	#
	#
	#
	#var input_vector = get_right_joystick_input()
	#var calculated_velocity: Vector3;
		#
	#
	## Rotate the player based on the right joystick input
	#if input_vector.length() > 0.3:  # If there's meaningful input from the right stick
		#rotate_player(input_vector, delta)
		#
		## Move the player forward in the direction it's facing
		#
		#calculated_velocity = move_forward(delta);
		#
	#player_body.velocity = calculated_velocity;
	#player_body.move_and_slide();

# Get input from the right joystick (assumes the standard mapping for joypad axis)
func get_right_joystick_input() -> Vector2:
	var x_axis = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)  # Right stick horizontal axis (X)
	var y_axis = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)  # Right stick vertical axis (Y)
	return Vector2(x_axis, y_axis)


""" Linear Floor Movement """
# Move the player in the passed in direction, regardless of what direction the player is facing. 
func move_in_direction(direction: Vector3) -> Vector3:
	return direction * lerp(convert_to_meters(MIN_SPRINT_SPEED), convert_to_meters(MAX_SPRINT_SPEED), float(player_body.speed_overall)/100)


## Calculates the velocity needed to make the player move the direction it's body is facing. This is what players will be doing most of the time
func move_forward() -> Vector3:
	# Compute the forward direction of the player (local forward is Z in Godot 3D)
	var forward_direction: Vector3 = global_transform.basis.z
	
	# Move the player in the forward direction
	return move_in_direction(forward_direction);
	

	
	
""" Rotation Functions """
## Rotate the player based on the input vector
func rotate_player(input_vector: Vector2, delta: float) -> void:
	# Compute the target direction based on the right stick input
	var target_angle = atan2(input_vector.y, -input_vector.x)
	
	
	# Interpolate smoothly towards the target angle using rotation speed
	var target_rotation = lerp_angle(player_body.global_rotation.y, target_angle, rotation_speed * delta)
	
	# Apply the new rotation to the player, keeping the Y axis fixed
	player_body.global_rotation.y = target_rotation
	
	
""" Jump Functions """
func jump_player() -> void:
	pass
	
static func convert_to_meters(kmph: float) -> float:
	return kmph * (5.0/18.0);
	
	
