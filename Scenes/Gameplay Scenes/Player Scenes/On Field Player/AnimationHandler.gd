extends Node3D
@onready var input_controller = $"../InputController"
@export var animation_tree: AnimationTree;
@onready var player: CharacterBody3D = get_owner();
const INPUTTYPE = InputAction.INPUTTYPE

@export var player_movement: Node3D;
@export var input_timer: Timer;


@export var action_button_hold_times: Dictionary = {
	"Through Ball":          0.0,
	"Lob Pass":              0.0,
	"Shoot":                 0.0,
	"Short Pass":            0.0,
	"Player Run Modifier":   0.0,
	"Finesse Shot Modifier": 0.0,
	"Protect Ball":          0.0,
	"Sprint":                0.0,
	"Move Player Up":        0.0,
	"Move Player Down":      0.0,
	"Move Player Left":      0.0,
	"Move Player Right":     0.0,
	"Skill Move Up":         0.0,
	"Skill Move Down":       0.0,
	"Skill Move Left":       0.0,
	"Skill Move Right":      0.0,
	"Tactics Up":            0.0,
	"Tactics Down":          0.0,
	"Tactics Left":          0.0,
	"Tactics Right":         0.0,
};
@export var order_of_importance: Dictionary = {
	"Through Ball":          0,
	"Lob Pass":              1,
	"Shoot":                 2,
	"Short Pass":            3,
	"Player Run Modifier":   4,
	"Finesse Shot Modifier": 5,
	"Protect Ball":          6,
	"Sprint":                7,
	"Move Player Up":        8,
	"Move Player Down":      8,
	"Move Player Left":      8,  
	"Move Player Right":     8,
	"Skill Move Up":         9,
	"Skill Move Down":       9,
	"Skill Move Left":       9,
	"Skill Move Right":      9,
	"Tactics Up":            10,
	"Tactics Down":          11,
	"Tactics Left":          12,
	"Tactics Right":         13,
}

## The amount of time (in seconds) before a button input is considered as "Holding" the button.
## Anything less than this threshold value will be considered a press
const hold_threshold: float = 0.3;

## The amount of time (in seconds) before a new button input is considered a completely new input.
const chain_input_time: float = 1.0;

## The Time the Last Button was pressed
var _last_pressed_time: float = 0.0;
var input_buffer: Array[InputAction] = [];

func _input(event: InputEvent) -> void:
	# First, we go through the actions defined and check if they have been pressed
	var time_started: float = Time.get_ticks_msec();
	for action: String in order_of_importance.keys():
		# Verify an action is pressed
		if not Input.is_action_pressed(action):
			continue;
			
		# Add Button Input to Input Buffer, which should still be valid or a new one
		action_button_hold_times[action] = time_started;
		var new_inputaction: InputAction = InputAction.new()
		new_inputaction.action = action;
		new_inputaction.type = INPUTTYPE.PRESS;
		input_buffer.push_back(new_inputaction)
	
	
	# Next, we start the timer if a button has been pressed and timer already timeout
	if input_timer.is_stopped() and input_buffer.size() > 0:
		input_timer.start(1.0);
	
	# Now, we check if any button has been released, building the InputAction
	for action: String in order_of_importance.keys():
		# Verify button has been released
		if not Input.is_action_just_released(action):
			continue;
			
		# Check the Type of Button Pressed given the amount of time it was held	
		var time_released: float = Time.get_ticks_msec();
		var delta: float = time_released - action_button_hold_times[action];
		var type: INPUTTYPE = INPUTTYPE.PRESS if delta <= hold_threshold * 1000 else INPUTTYPE.HOLD;
		
		# Verify the button held time is considered a Hold
		if type != INPUTTYPE.HOLD:
			continue;
			
		# Now we change the InputType of the latest action and add timing info
		var latest_input_of_action: InputAction = find_latest_input(action);
		if latest_input_of_action == null:
			continue
		latest_input_of_action.type = INPUTTYPE.HOLD;
		latest_input_of_action.time_pressed = delta;
			
	


## Sorts the inputs so the Trie can search for it in a consistent order
func sort_inputs(inputs: Array[InputAction]) -> Array[InputAction]:
	inputs.sort_custom(func(a: InputAction, b: InputAction): return order_of_importance[a.action] < order_of_importance[b.action]);
	return inputs

func clear_action_timers() -> void:
	for action in action_button_hold_times.keys():
		action_button_hold_times[action] = 0.0;

func find_latest_input(desired_action: String) -> InputAction:
	for index: int in range(-1, -input_buffer.size(), -1):
		if input_buffer[index].action == desired_action:
			return input_buffer[index];
	return null
#
#func handle_attacking_inputs(event: InputEvent, action: String, input_type: InputType) -> void:
	#match action:
		#"Move Player Up", "Move Player Down", "Move Player Left", "Move Player Right":
			## Get Direction of PLayer's Directional movement
			#var forward_direction: Vector2 = Input.get_vector("Move Player Left", "Move Player Right", "Move Player Down", "Move Player Up", 0.3);
			#
			## Rotate Player Body to this direction
			#player_movement.rotate_player(forward_direction, 1.0/60.0);
			#
			## Now, we set the velocity of player
			#player.velocity = player_movement.move_forward();
			#
	#player.move_and_slide()





#func _on_input_controller_input_detected(event: InputEvent, action: String, input_type: InputType):
	## First Thing First, if ball in not in play, listen to only special cases
	#if !player.ball_in_play:
		#return
	#
	#
	#
	## First thing first, we need to check if player is currently being controlled by user or AI
	#if !player.user_controlled:
		#return
#
	## Yes, player is user-controlled so we need to handle controller inputs
	#
	## But first, check if player input will be attacking or defending
	#if player.team_possesion:
		## Yes, so we are attacking so we only consider attacking inputs
		#handle_attacking_inputs(event, action, input_type);
	#else:
		##handle_defending_inputs(event, action, input_type);


func _on_input_buffer_timer_timeout() -> void:
	# First we sort our input buffer
	input_buffer = sort_inputs(input_buffer);
	
	# Now we search through the Trie Tree to check if Inputs are valid
	for input: InputAction in input_buffer:
		print(input.action + " " + str(input.type) + " " + str(input.time_pressed))
	
	# Now we call appropiate function
	
	
	# Now we reset the input buffer
	input_buffer.clear();
