class_name Team extends Resource


""" Identifying Information """
@export var Name: String;
@export var Display_Name: String;
@export var Nick_Name: String;
@export var Logo_Path: String;  ## ALERT The Images will now be stored in the user:// file system, the image will be in the folder "Team Logos" and will simply be the ID.png
@export var ID: int;
@export var Name_Code: String;

""" Regional Information """
@export var City: String;
@export var _Territory: int;

""" Team Info """
@export var Rating: int;
@export var Team_Stadium: Stadium;
@export var Gender: bool;

""" Club History """
@export var Trophies: Array
@export var League_History: Array

""" Player and Manager Info """
@export var _Manager: Manager
@export var Players: Array[Player]


## Function to save the image in the filesystem for the given team. Will save image with new identifier
## if team doesn't have a flag saved, otherwise it will overwrite the previous image
func save_image_for_team(image: Image) -> void:
	# First we need to resize the image and compress it before it can be stored
	image.resize(120, 80, 2);
	image.compress(Image.COMPRESS_BPTC);
	
	# Second we need to get the current number of territory flags in "Territory Flags" folder
	var logo_path: String = "user://Images/Team Logos/";
	var num_images: int = get_num_import_files(logo_path);
	print(num_images)

	# Now we need to save this image using the number unique identifier or previous name is already located
	var save_path: String = logo_path + str(num_images + 1) + ".png";
	if Logo_Path.begins_with(logo_path):
		save_path = Logo_Path;
	image.save_png(save_path);
	
	# Now we save this path inside of the terr to have forever. We will also use this path to delete the image
	Logo_Path = save_path;

## Get the image for this team. Null is returned if no image exists for this Team
func get_team_logo() -> Image:
	# Generate Load Path
	var load_path: String = Logo_Path
	
	# Load Image
	if FileAccess.file_exists(load_path):
		var image_data_compressed: CompressedTexture2D = load(load_path);
		var image_data: Image = image_data_compressed.get_image()
		if image_data == null:
			return null
		return image_data;
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

