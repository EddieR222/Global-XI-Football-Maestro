extends TextureButton
var filename: String;

func team_selected(team: Team) -> void:
	# Get and Decompress Logo 
	var logo: Image = team.get_team_logo();
	var texture;
	
	if logo != null:
		texture = ImageTexture.create_from_image(logo);
	else:
		var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
		texture = default_icon;
	
	# Display it on TextureButton
	texture_normal = texture
	
