extends Label


func display_player(player: Player) -> void:
	# Get Player Shirt Number
	var shirt_number: int = player.Club_Shirt_Number;
	
	# Get Player Name
	var player_name: String = player.Name;
	var player_name_split: Array[String] = player_name.strip_edges().split(" ")
	var first_name: String = player_name_split.pop_front();
	var last_name: String = player_name_split.pop_back();
	var first_name_letter: String = first_name.left(1);
	
	# Display
	text = str(shirt_number) + " " + first_name_letter + ". " + last_name
