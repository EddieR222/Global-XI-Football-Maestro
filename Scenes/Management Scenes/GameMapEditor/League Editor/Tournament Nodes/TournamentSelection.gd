extends OptionButton


func prepare_tour_select(tours: Dictionary, group_name: String) -> void:
	# First we add group_name as disabled option
	add_item(group_name);
	set_item_disabled(item_count - 1, true);
	
	
	# We iter through the tournaments and add them
	for tour: Tournament in tours.values():
		# Get Tournament Name
		var tour_name: String = tour.Name;
		# Get Tournament Logo
		var logo: Image = tour.Logo;
		var texture: Texture2D
		if logo != null:
			logo.decompress();
			texture = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture = default_icon;
		# Add to item list
		add_icon_item(texture, tour_name);
