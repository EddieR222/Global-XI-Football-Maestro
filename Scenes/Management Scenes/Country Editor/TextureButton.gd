extends TextureButton


func territory_selected(t: Territory):
	var flag: Image = t.get_territory_image();
	
	if flag != null:
		texture_normal = ImageTexture.create_from_image(flag);
	else:
		var default_icon: CompressedTexture2D = load("res://Assets/2D Assets/Images/Icons/NO_FLAG_ICON.png");
		texture_normal = default_icon;
	
	
