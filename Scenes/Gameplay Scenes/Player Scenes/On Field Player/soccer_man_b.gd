extends CharacterBody3D


## The player instance that is this CharacterBody3D is controlling. This will have all information for the player like position, role, height, weight, speed, etc
var player: Player;

@export var user_controlled: bool = true;
@export var team_possesion: bool = true;
@export var ball_in_play: bool = true;

# Debug
@export var speed_overall: int = 100;



## Handles the player input
func _physics_process(delta: float) -> void:
	pass
