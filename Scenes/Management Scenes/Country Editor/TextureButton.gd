extends TextureButton


func territory_selected(t: Territory):
	var flag: Image = t.get_territory_image();
	
	if flag != null:
		flag.decompress();
	
		texture_normal = ImageTexture.create_from_image(flag);
	else:
		var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
		texture_normal = default_icon;
	
	
