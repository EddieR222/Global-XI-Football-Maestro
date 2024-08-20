extends Button

func display_data(txt: String, img: Image) -> bool:
	# First we simply display the text
	text = txt;
	
	# Second, we display the img or don't if image is null
	if img != null:
		var texture: Texture2D = Texture2D.new();
		texture.create_from_image(img)
		icon = texture
		return true
	icon = null	
	return false
