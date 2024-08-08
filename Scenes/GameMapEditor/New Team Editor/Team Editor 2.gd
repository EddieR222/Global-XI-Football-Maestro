extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# First thing first we need to read in the settings
	read_in_settings()
	
	
	
func read_in_settings() -> void:
	# First we need to read in the colors
	var background_color: ColorRect = get_node("BackgroundColor")
	background_color.color = GameSettings.DEFAULT_SECONDARY_COLOR;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
