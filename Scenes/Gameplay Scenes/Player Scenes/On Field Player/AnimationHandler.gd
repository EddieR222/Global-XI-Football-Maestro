extends Node3D
const InputType = InputController.InputType
@onready var input_controller = $"../InputController"
@export var animation_tree: AnimationTree;
@onready var player: CharacterBody3D = get_owner();


@export var player_movement: Node3D;


func ball_out_of_play() -> void:
	pass


func handle_attacking_inputs(event: InputEvent, action: String, input_type: InputType) -> void:
	match action:
		"Move Player Up", "Move Player Down", "Move Player Left", "Move Player Right":
			# Get Direction of PLayer's Directional movement
			var forward_direction: Vector2 = Input.get_vector("Move Player Left", "Move Player Right", "Move Player Down", "Move Player Up", 0.3);
			
			# Rotate Player Body to this direction
			player_movement.rotate_player(forward_direction, 1.0/60.0);
			
			# Now, we set the velocity of player
			player.velocity = player_movement.move_forward();
			
	player.move_and_slide()


func handle_defending_inputs(event: InputEvent, action: String, input_type: InputType) -> void:
	pass
	


func _on_input_controller_input_detected(event: InputEvent, action: String, input_type: InputType):
	# First Thing First, if ball in not in play, listen to only special cases
	if !player.ball_in_play:
		return
	
	
	
	# First thing first, we need to check if player is currently being controlled by user or AI
	if !player.user_controlled:
		return

	# Yes, player is user-controlled so we need to handle controller inputs
	
	# But first, check if player input will be attacking or defending
	if player.team_possesion:
		# Yes, so we are attacking so we only consider attacking inputs
		handle_attacking_inputs(event, action, input_type);
	else:
		handle_defending_inputs(event, action, input_type);
