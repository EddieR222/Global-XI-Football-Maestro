extends ItemList

""" Constants """
@onready var GROUP_NAME_COLOR: Color = Color(0.486, 0.416, 0.4);

func prepare_item_list(team_list: Dictionary, group_name: String) -> void:
	# Add Group Name first, to show that the teams below are part of this group
	var group_name_index: int = add_item(group_name, null, false);
	set_item_custom_bg_color(group_name_index, GROUP_NAME_COLOR);
	
	# Now add all teams in Dictionary
	for team: Team in team_list.values():
		var team_name: String = team.Name;
		var logo: Image = team.Logo;
		var texture: Texture2D
		if logo != null:
			logo.decompress();
			texture = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture= default_icon;
		# Add to item list
		var index: int = add_item(team_name, texture, true);
		
		#Now we set metadata
		set_item_metadata(index, team);
