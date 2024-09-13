extends Button

func display_data(txt: String, img: Image) -> bool:
	# First we simply display the text
	text = txt;
	
	# Second, we display the img or don't if image is null
	if img != null:
		icon = ImageTexture.create_from_image(img)
		return true
	icon = null	
	return false
