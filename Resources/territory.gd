class_name Territory
extends Resource
## The class for storing information about a Territory
##
## The functions here are specific for editing and getting information
## about the territory. The territories are identifiable by a unique ID number


@export_category("Identifying Information")

## The unique ID for the territory. All of the game code uses this ID 
## to identify the territory. 
@export 
var ID: int:
	get:
		return ID
	set(value):
		ID = value;

## The name for the territory
@export 
var Name: String:
	get: return Name;
	set(name):
		Name = name;

## The CoTerritory for this territory.[br]
## CoTerritories are for special cases where this country is part of another country.[br]
## For example, Hawaii is a part of the United States of America but it is included as its own
## territory, meaning all hawaiian players can play for both Hawaii or the United States.[br]
## In other words, CoTerritories are the "owner" of this territory
## NOTE NEVER use this to point two territories to each other
@export 
var CoTerritory: Territory:
	get: return CoTerritory;
	set(terr): CoTerritory = terr;

## The CODE is the Three Letter Code Name that will be used to display on the scoreboard during the match.[br]
## It should always be three letters and similar to the territory name itself.[br]
## For example, the code for CANADA is CAN
@export 
var Code: String:
	get: return Code;
	set(code): 
		if code.length() > 4: return 
		else: Code = code

## The Path in the User folder where the flag is being stored. We use this string to both store and retrieve the 
## flag that the user stores for this territory.[br]
## Once the path is set, the previous flag will be OVERWRITTEN if a new flag is provided
@export 
var Flag_Path: String;

@export_category(" Country Information")

## The population of the territory. The units will be in millions so if the number here is 2 then the population
## of this territory is 2 million
@export 
var Population: float: # In Millions
	get: return Population;
	set(pop): Population = pop;

## The Area of the territory. The units will be in Thousands Square Meters so if the number here is 10 then the 
## area is 10,000 square meters
@export 
var Area: float: #In Thousands
	get: return Area;
	set(area): Area = area;
## The GDP of the territory. The units are in Billions so if the number is 10 then the GDP
## of this territory is 10 Billion 
@export 
var GDP: float: # In Millions
	get: return GDP;
	set(gdp): GDP = gdp;


@export_category("Name Directory")

## This is the list of First Names to use for this territory.[br]
## The array contains the Name_ID which is used to get it from the Name Directory.
@export 
var First_Names: Array[String]:
	get: return First_Names;
	set(names): 
		for name in names:
			if name.length() < 2:
				return
			
		First_Names = names;

## This is the list of Last Names to use for this territory.[br]
## The array contains the Name_ID which is used to get it from the Name Directory.
@export 
var Last_Names: Array[String]:
	get: return Last_Names;
	set(names): 
		for name in names:
			if name.length() < 2:
				return
			
		Last_Names = names;


@export_category("Ratings")

## The Rating of the National Team for this territory. This number is the average of all players and the ratings will
## follow the Bell Curve of probability. The Rating should be between 0 - 100 but more releastically between 20 - 65
@export
var Rating: float:
	get: return Rating;
	set(rating): 
		if rating < 0 or rating > 100:
			return
		else:
			Rating = rating;

## The Rating (or Elo to be exact) of the Domestic League in this territory. This Elo is a good marker of how strong the league
## is compared to the other leagues around the world. This value will either decrease or increase depending on the performance of the teams against
## teams of other leagues. The higher the number the better the domestic league
@export
var League_Elo: float:
	get: return League_Elo;
	set(elo): 
		if elo < 0:
			return
		else:
			League_Elo = elo;


@export_category("Tournaments")

## The Tournament IDs of the leagues for this territory. These will used to gather the Tournament Details for the Leagues
@export
var Leagues: Array[Tournament];

## The Tournament ID of the League Cup. This can be thought of as the Domestic Cup of the League. If there is not a League Cup then this will be -1
@export
var League_Cup: Tournament

## The Tournament ID of the Super Cup. If there is not a Super Cup then this will be -1
@export
var Super_Cup: Tournament

## The other tournaments within this Territory. This will include anything besides the Leagues, Super Cup, and Domestic Cup.[br]
## For example, the Carabao Cup isn't the Domestic Cup but still a tournament hosted in the English Leagues
@export
var Tournaments: Array[Tournament];

@export_category("Teams")

## The Team ID of the National Team for this territory. If no National Team, the ID here will be -1
@export
var National_Team: Team

## The Team IDs of all Club Teams inside this territory. For ranking purposes, this list will also be ranked according to how strong each team is.[br]
## If empty, there are no Club Teams for this territory
@export
var Club_Teams_Rankings: Array[Team]:
	get: return Club_Teams_Rankings;
	set(teams): Club_Teams_Rankings = teams;


## Function to save the image in the filesystem for the given terr_id. Will save image with new identifier
## if territory doesn't have a flag saved, otherwise it will overwrite the previous image
func save_image_for_terr(image: Image) -> void:
	# Validate
	if image == null:
		return
	
	# First we need to resize the image and compress it before it can be stored
	image.resize(120, 80, 2);
	image.compress(Image.COMPRESS_BPTC);
	
	# Second we need to get the current number of territory flags in "Territory Flags" folder
	var flag_path: String = "user://Images/Territory Flags/";
	var num_images: int = get_num_import_files(flag_path);
	print(num_images)

	# Now we need to save this image using the number unique identifier or previous name is already located
	var save_path: String = flag_path + str(num_images + 1) + ".png";
	if Flag_Path.begins_with(flag_path):
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
		var image_data_compressed: Image = Image.load_from_file(load_path);
		if image_data_compressed == null:
			return null
		image_data_compressed.decompress();
		return image_data_compressed;
	else:
		return null
		
func get_num_import_files(image_folder_path: String) -> int:
	var flag_folder: DirAccess = DirAccess.open(image_folder_path);
	var files: PackedStringArray= flag_folder.get_files_at(image_folder_path);
	
	var num_imports: int = 0;
	for file: String in files:
		if file.get_extension() == "png":
			num_imports += 1;
			
	return num_imports
