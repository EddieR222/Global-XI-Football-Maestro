extends TextureButton


func team_selected(team: Team) -> void:
	# Get Team Logo
	var logo: Image = team.get_team_logo();
	var texture: Texture2D;
	if logo != null:
		texture = ImageTexture.create_from_image(logo);
	else:
		var default_icon: CompressedTexture2D = load("res://Images/Icons/NO_LOGO_ICON.png");
		texture = default_icon;
	
	# Display it on TextureButton
	texture_normal = texture
