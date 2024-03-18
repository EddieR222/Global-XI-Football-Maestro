class_name Team extends Resource


""" Identifying Information """
@export var Name: String;
@export var Display_Name: String;
@export var Nick_Name: String
#@export var Logo: Image   ## ALERT The Images will now be stored in the res:// file system, the image will be in the folder "Team Logos" and will simply be the ID.png
@export var ID: int;
@export var Name_Code: String;

""" Regional Information """
@export var Territory_Name: String;
@export var Territory_ID: int;
@export var City: String;

""" Team Info """
@export var Rating: int;
@export var League_Name: String;
@export var League_ID: int;
@export var Stadium_ID: int;
@export var Rivals_Name: String;
@export var Rivals_ID: String;


 
""" Club History """
@export var Trophies: Array
@export var League_History: Array


""" Player and Manager Info """
@export var Manager_Name: String;
@export var Manager_ID: int; 
@export var Players: Array[int]


## Get the image for this team. Null is returned if no image exists for this Team
func get_team_logo() -> Image:
	# Generate Load Path
	var load_path: String = "res://Images/Team Logos/" +  str(ID) + ".png"
	
	# Load Image
	if FileAccess.file_exists(load_path):
		var logo_texture: Texture2D = load(load_path)
		if logo_texture != null:
			var logo: Image = logo_texture.get_image()
			return logo
		else:
			return null
	return null
