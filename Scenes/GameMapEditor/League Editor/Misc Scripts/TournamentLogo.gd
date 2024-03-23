extends TextureButton


func tour_selected(t: Tournament) -> void:
	# Get and Decompress Logo 
	var logo: Image = t.Logo;
	var texture;
	
	if logo != null:
		logo.decompress();
		texture = ImageTexture.create_from_image(logo);
	else:
		var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
		texture = default_icon;
	
	# Display it on TextureButton
	texture_normal = texture


func clear_selection() -> void:
	var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
	var texture = default_icon;
	
	# Display it on TextureButton
	texture_normal = texture
