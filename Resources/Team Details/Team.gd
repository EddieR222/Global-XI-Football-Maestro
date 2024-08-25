class_name Team extends Resource



""" Identifying Information """
@export var Name: String;
@export var Nickname: String;
const Logo_Path_Dir: String = "user://Images/Team Logos/";
@export var Logo_Filename: String;  ## ALERT The Images will now be stored in the user:// file system, the image will be in the folder "Team Logos" and will simply be the ID.png
@export var Owner_Team: Team;

## The Team ID of this team. It is a 32 bit number meaning the MAXIMUM number of Teams allowd in game is 2,147,483,647 (unlikely to ever meet this number)
@export var ID: int;

## The 3 or 4 letter Name_Code 
@export var Name_Code: String;

""" Regional Information """
@export var City: String;
@export var _Territory: int; #32 bits

""" Team Info """
@export var Rating: int; #8 Bits
@export var _Stadium: Stadium;
@export var Gender: bool; # 1 bit

""" Team Priorities """
enum PRIORITY {VERY_LOW = 0, LOW = 1, MEDIUM = 2, HIGH = 3, VERY_HIGH = 4, CRITICAL = 5};
## All the priorities by default will be VERY_LOW
@export var Youth_Development: PRIORITY = PRIORITY.VERY_LOW;
@export var Financial_Stability: PRIORITY = PRIORITY.VERY_LOW;
@export var Reputation_Branding: PRIORITY = PRIORITY.VERY_LOW;
@export var Facility_Maintenance: PRIORITY = PRIORITY.VERY_LOW;
@export var Domestic_Success: PRIORITY = PRIORITY.VERY_LOW;
@export var International_Success: PRIORITY = PRIORITY.VERY_LOW;

""" Club History """
@export var Trophies: Array
@export var League_History: Array

""" Staff Info """
@export var _Manager: Manager


""" Team Tactics """
@export var Starting_XI: Array[Player]
@export var Subs: Array[Player]
@export var Reserves: Array[Player];
@export var Team_Tactics: TeamTactics


## Function to save the image in the filesystem for the given team. Will save image with new identifier
## if team doesn't have a flag saved, otherwise it will overwrite the previous image
func save_image_for_team(image: Image) -> bool:
	# First we need to validate that the image passed in is valid
	if image == null:
		return false;
		
	# Second, if team already has a logo saved, we need to ensure we delete it in order to ensure we don't leave unneeded images
	if Logo_Filename != null and not Logo_Filename.is_empty():
		DirAccess.remove_absolute(Logo_Path_Dir + Logo_Filename)
	
	# Now we need to resize the image
	image.resize(120, 80, 2);
	
	# Now we need to get the current number of territory flags in "Territory Flags" folder
	var logo_path: String = "user://Images/Team Logos/";

	# Now we need to save this image using the number unique identifier or previous name is already located
	var save_path: String = logo_path + uuid.v4() + ".png";
	var error: Error = image.save_png(save_path);
	if error != OK:
		return false
	
	# Now we save this path inside of the terr to have forever. We will also use this path to delete the image
	Logo_Filename = save_path;
	return true

## Get the image for this team. Null is returned if no image exists for this Team
func get_team_logo() -> Image:
	# Load Image
	if FileAccess.file_exists(Logo_Filename):
		var image: Image = Image.load_from_file(Logo_Filename)
		if image != null:
			return image
	
	
	return null
	
	
func get_num_import_files(image_folder_path: String) -> int:
	var flag_folder: DirAccess = DirAccess.open(image_folder_path);
	var files: PackedStringArray= flag_folder.get_files_at(image_folder_path);
	
	var num_imports: int = 0;
	for file: String in files:
		if file.get_extension() == "png":
			num_imports += 1;
			
	return num_imports

