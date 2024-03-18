class_name Territory
extends Resource


""" Identifying Information """
@export var Territory_ID: int;
@export var Territory_Name: String;
@export var CoTerritory_ID: int;
@export var CoTerritory_Name: String;
@export var Code: String;
#@export var Flag: Image; # Too much area, now image is just the territory_id.png inside Terriotry Flag Folder

""" Country Information """
@export var Population: float; # In Millions
@export var Area: float; #In Thousands
@export var GDP: float; # In Billions


""" Name Database """
@export var First_Names: PackedStringArray;
@export var Last_Names: PackedStringArray;


""" Soccer Ratings (Domestic and International) """
@export var Rating: float;
@export var League_Elo: float;

""" Tournaments in Country """	
@export var Leagues: Array[int]
@export var League_Cup: int = -1 #index inside of Tournaments
@export var Super_Cup: int = -1 #index inside of Tournaments 
@export var Tournaments: Array[int]

""" Teams """
@export var National_Team: int #team_id

""" Rankings """
@export var Club_Teams_Rankings: Array[int] # Array[Team_ID]



## Function to load the image for this territory
func get_territory_image() -> Image:
	# Generate Load Path
	var load_path: String = "res://Images/Territory Flags/" + str(Territory_ID) + ".png"
	
	# Load Image
	if FileAccess.file_exists(load_path):
		var flag_texture: Texture2D = load(load_path)
		if flag_texture != null:
			var flag: Image = flag_texture.get_image()
			return flag
		else:
			return null
	else:
		return null
