extends Node3D
@onready var input_controller = $"../InputController"
@export var animation_tree: AnimationTree;
@onready var player: CharacterBody3D = get_owner();
const INPUTTYPE = InputAction.INPUTTYPE

@export var player_movement: Node3D;
@export var chain_input_timer: Timer;
@export var max_hold_timer: Timer;



@export var order_of_importance: Dictionary = {
	"Through Ball":          0,
	"Lob Pass":              1,
	"Shoot":                 2,
	"Short Pass":            3,
	"Player Run Modifier":   4,
	"Finesse Shot Modifier": 5,
	"Protect Ball":          6,
	"Sprint":                7,
	#"Move Player Up":        8,
	#"Move Player Down":      8,
	#"Move Player Left":      8,  
	#"Move Player Right":     8,
	#"Skill Move Up":         9,
	#"Skill Move Down":       9,
	#"Skill Move Left":       9,
	#"Skill Move Right":      9,
	"Tactics Up":            10,
	"Tactics Down":          11,
	"Tactics Left":          12,
	"Tactics Right":         13,
}


## The amount of time (in seconds) before a button input is considered as "Holding" the button.
## Anything less than this threshold value will be considered a press
const HOLD_THRESHOLD: float = 0.3;

## The Maximum amount of time (in seconds) a button can be pressed. Anything above this and the input will be erased
const HOLD_MAXIMUM: float = 1.0;

## The amount of time (in seconds) before a new button input is considered a completely new input.
const CHAIN_INPUT_TIME: float = 0.5;

## The amount fo Strength needed to not be considered a deadzone
const DEADZONE_STRENGTH: float = 0.3;

## The Time the Last Button was pressed
var _last_pressed_time: float = 0.0;
var input_buffer: Array[InputDetails] = [];


var movement_stick_input: Vector2 = Vector2.ZERO;
var skill_move_stick_input: Vector2 = Vector2.ZERO;



var input_trie_map: TrieTree = TrieTree.new();

func _ready():
	# DEBUG: Set up simple movement button maps
	var move_player= 0
	pass
	


func _input(event: InputEvent) -> void:
	# First, we check if input buffer has any current button presses
	var previous_presses: bool = true if input_buffer.size() > 0 else false

	# Handle New Button Pressed
	handle_new_button_presses();
	
	# Next, we start the timer if a button has been pressed and timer already timeout
	handle_timers(previous_presses);
	
	# Handle Any Button Releases
	handle_new_button_releases();
		

## Wrapper function for Time.get_ticks_msec() that returns the value in seconds, as a float.
func get_ticks() -> float:
	return float(Time.get_ticks_msec()) / 1000


func _physics_process(delta: float) -> void:
	# Starting off, we make the player's velocity zero, only changing it if we have valid movement inputs
	player.velocity = Vector3.ZERO
	# First, we update directional inputs
	movement_stick_input = Input.get_vector("Move Player Left", "Move Player Right", "Move Player Up", "Move Player Down", DEADZONE_STRENGTH);
	skill_move_stick_input = Input.get_vector("Skill Move Left", "Skill Move Right", "Skill Move Up", "Skill Move Up", DEADZONE_STRENGTH);
	
	# For each physics process, we check to see if directional inputs have been given
	if movement_stick_input != Vector2.ZERO:
		# Rotate Player Body to this direction
		player_movement.rotate_player(movement_stick_input, 1.0/60.0);
		
		# Now, we set the velocity of player
		player.velocity = player_movement.move_forward();
		
		
		
	
		

	player.move_and_slide();


## Sorts the inputs so the Trie can search for it in a consistent order
func filter_and_sort_inputs(inputs: Array[InputDetails]) -> Array[InputDetails]:
	inputs.sort_custom(func(a: InputDetails, b: InputDetails): return a.button_importance < b.button_importance);
	
	var filtered_input_buffer: Array[InputDetails] = [];
	for input: InputDetails in inputs:
		if input.released_at > 0:
			filtered_input_buffer.push_back(input)
	
	return filtered_input_buffer
	
func remove_finished_inputs() -> void:
	var filtered_input_buffer: Array[InputDetails] = [];
	for input: InputDetails in input_buffer:
		if Input.is_action_pressed(input.action):
			filtered_input_buffer.push_back(input)
	
	input_buffer = filtered_input_buffer;
	return

func find_latest_input(desired_action: String) -> InputDetails:
	for index: int in range(-1, -1 * (input_buffer.size() + 1), -1):
		if input_buffer[index].action == desired_action:
			return input_buffer[index];
	return null
#

func is_any_button_pressed() -> bool:
	for action: String in order_of_importance.keys():
		if Input.is_action_pressed(action):
			return true
	return false

func handle_timers(previous_presses: bool) -> void:
	var current_press: bool = is_any_button_pressed();
	
	# If there were previous presses before handling new presses, we know we are chaining inputs
	if previous_presses and current_press:
		chain_input_timer.start(CHAIN_INPUT_TIME);
		return
		
	# If there were not any presses and we do have new ones, we start the maximum hold time
	if not previous_presses and current_press:
		max_hold_timer.start(HOLD_MAXIMUM);
		return
		
	

func handle_directional_inputs() -> void:
	# Starting off, we make the player's velocity zero, only changing it if we have valid movement inputs
	player.velocity = Vector3.ZERO
	
	# For each physics process, we check to see if directional inputs have been given
	if movement_stick_input != Vector2.ZERO:
		# Rotate Player Body to this direction
		player_movement.rotate_player(movement_stick_input, 1.0/60.0);
		
		# Now, we set the velocity of player
		player.velocity = player_movement.move_forward();
		
		
		
	
		

	player.move_and_slide();
	
	
## Called to check for new Button Presses by the Player. If a button is pressed, it simply adds it to the the input buffer.
## Button will be added to the input buffer in the order of importance
func handle_new_button_presses() -> bool:
	# Get the current time in seconds since start of engine
	var time_started: float = get_ticks()
	var new_presses: bool = false;
	
	# Loop through actions
	for action: String in order_of_importance.keys():
		# Verify an action is just pressed
		if not Input.is_action_just_pressed(action):
			continue;
			
		# Set new_presses as true
		new_presses = true;	
			
		# Add Button Input to Input Buffer, which should still be valid or a new one
		var new_input_details: InputDetails = InputDetails.new()
		new_input_details.action = action;
		new_input_details.type = INPUTTYPE.PRESS;
		new_input_details.pressed_at = time_started
		new_input_details.button_importance = order_of_importance[action];
		input_buffer.push_back(new_input_details);
		
	return new_presses

## Called to check if a new Button Releases by the Player. If a button is released, this will get the latest occurence of that action in the 
## input buffer and update its details (such as time released, type of press, etc). Does not add or remove from input buffer
func handle_new_button_releases() -> void:
	# Get the time released
	var time_released: float = get_ticks();
	
	# Loop through all actions
	for action: String in order_of_importance.keys():
		# Verify button has just been released
		if not Input.is_action_just_released(action):
			continue;
			
		# Check the Type of Button Pressed given the amount of time it was held	
		var latest_action_press: InputDetails = find_latest_input(action);
		if latest_action_press == null: continue;
		
		# Update input details
		latest_action_press.released_at = time_released;
	
		
		# Verify the button held time is considered a Hold
		var delta: float = time_released - latest_action_press.pressed_at;
		if delta <= HOLD_THRESHOLD:
			continue;
			
		# Now we change the InputType to HOLD of the latest action
		# Also, given how button holds are always the end of combos, we need to clear input buffer
		latest_action_press.type = INPUTTYPE.HOLD;
		_on_input_buffer_timer_timeout()
	
	

func _on_input_buffer_timer_timeout() -> void:
	# First we sort our input buffer
	input_buffer = filter_and_sort_inputs(input_buffer);
	
	# Now we search through the Trie Tree to check if Inputs are valid
	var msg: String = ""
	for input: InputDetails in input_buffer:
		msg += input.action + " " + str(input.type) + " "
	print(msg)
	
	# Now we call appropiate function
	max_hold_timer.stop()
	
	# Now we reset the input buffer
	remove_finished_inputs();

func _on_max_hold_timer_timeout() -> void:
	# First we sort our input buffer
	input_buffer = filter_and_sort_inputs(input_buffer);
	
	# Now we search through the Trie Tree to check if Inputs are valid
	var msg: String = ""
	for input: InputDetails in input_buffer:
		msg += input.action + " " + str(input.type) + " "
	print(msg)
	# Now we call appropiate function
	chain_input_timer.stop()
	
	# Now we reset the input buffer
	remove_finished_inputs();

class InputDetails:
	# Identifying Info
	var action: String
	var type: INPUTTYPE;
	var button_importance: int;
	
	# Details
	var pressed_at: float = 0.0;
	var released_at: float = 0.0;
	var direction: Vector2 = Vector2.ZERO;
	var strength: float = 0.0;
	



