extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	## Create a new test Player
	var player: Player = Player.new();
	
	## Set Player Height and Weight and other details to test it
	player.set_player_age(1);
	player.set_player_height(2);
	player.set_player_weight(3);
	player.set_player_overall_rating(4);
	player.set_player_potential_rating(5);
	
	
	## Print value out
	print("%16x" % player.Key_Details)
	
	## Set foot
	player.set_player_foot(true);
	
	
	
	## Print Value
	print(player.get_player_age());
	print(player.get_player_club_team())
	print(player.get_player_height())



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
