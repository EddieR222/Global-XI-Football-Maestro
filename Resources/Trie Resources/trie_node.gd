class_name TrieNode
extends Resource

const InputType = InputController.InputType

@export var children: Dictionary = {}; # Key: InputAction Value: TrieNode
@export var leaf_node: bool = false;
@export var input_action: InputAction;
@export var animation: Animation;

