class_name Territory
extends Resource


""" Identifying Information """
@export var Territory_ID: int;
@export var Territory_Name: String;
@export var CoTerritory_ID: int;
@export var CoTerritory_Name: String;
@export var Code: String;
@export var Flag_Path: String;

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


## Function to save the image in the filesystem for the given terr_id. Will save image with new identifier
## if territory doesn't have a flag saved, otherwise it will overwrite the previous image
func save_image_for_terr(image: Image) -> void:
	# First we need to resize the image and compress it before it can be stored
	image.resize(120, 80, 2);
	image.compress(Image.COMPRESS_BPTC);
	
	# Second we need to get the current number of territory flags in "Territory Flags" folder
	var flag_path: String = "res://Images/Territory Flags/";
	var flag_folder: DirAccess = DirAccess.open(flag_path);
	var num_images: int = flag_folder.get_files().size(); 

	# Now we need to save this image using the number unique identifier or previous name is already located
	var save_path: String = flag_path + str(num_images + 1) + ".png";
	if Flag_Path.length() > 12:
		save_path = Flag_Path;
	image.save_png(save_path);
	
	# Now we save this path inside of the terr to have forever. We will also use this path to delete the image
	Flag_Path = save_path;

## Function to load the image for this territory. Can return null if image doesn't exist so check for null upon return
func get_territory_image() -> Image:
	# Generate Load Path
	var load_path: String = Flag_Path
	
	# Load Image
	if FileAccess.file_exists(load_path):
		var image_data = Image.new();
		var error = image_data.load(load_path);
		if error != OK:
			return null
		return image_data;
	else:
		return null
