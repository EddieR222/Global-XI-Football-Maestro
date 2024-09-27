extends Node3D


@export var animation_tree: AnimationTree;
@onready var player: CharacterBody3D = get_owner();

func _physics_process(delta):
	var forward_direction = global_transform.basis.z
	
	animation_tree.set("parameters/IWR/blend_position", Vector2(player.velocity.x, player.velocity.z).normalized());
