class_name Player extends Resource

@export_category("Identifying Information")

## The Unique ID of the Player
@export var ID: int; #32 bits

## The Name of the Player
@export var Name: String

## The Beginning of the Face Path 
const Face_Path_Dir: String = "user://Images/Player Faces/";

## The Path for the Player's Face Image
@export var Face_Path: String;

## The NickName of the Player
@export var NickName: String

## The BirthDate of the Player, stored as an array of integers in the format of (Month, Day, Year)
@export var BirthDate: Array[int];

## The Age of the Player 
@export var Age: int;


@export_category("Key Details")
@export var Right_Foot: bool; # whether player is right foot dominate
@export var Skill_Moves: int; #out of 5 stars
@export var Weak_Foot: int; #out of 5 stars

## Current Player Morale, how motivated or happy is the player. 
## The BreakDown of the Morale is as follows
## 1. Morale > 90  Very Happy
## 2. Morale > 75  Happy
## 3. Morale > 25  Neutral
## 4. Morale < 25  UnHappy
## 5. Morale < 10  Very UnHappy
@export var Morale: int;

## The current Sharpness of the Player.
## The BreakDown of the Sharpness is as follows
## 1. Sharpness > 90  Very Fit
## 2. Sharpness > 75  Fit
## 3. Sharpness > 25  Neutral
## 4. Sharpness < 25  UnFit
## 5. Sharpness < 10  Very UnFit
@export var Sharpness: int;

## The Positions of the Player  (array of Positons Enums)
@export var Positions: Array[int]

## The current position for the player for their Club Team
@export var Club_Position: int;

## The current position for the player for their National Team
@export var National_Position: int;

## The Market Value of the Player (in US Dollars in Millions)
@export var Market_Value: float

## The Weekly Wage the Player is Earning (always in thousands of US Dollars)
@export var Wage: float

## The current training results; Higher the number the harder and better the player is training
@export var Training: int

## This details if the player is healthy = 1, injured = 2, or injury prone = 3
@export var Condition: int

## The Specific Injury if has any
@export var Injury: int

## The Number of Months out for injury
@export var Months_Injured: float;

## The current stamina of the player
@export var Stamina_Level: int;

## The Shirt Number of the Player in the current team
@export var Club_Shirt_Number: int;
@export var National_Team_Number: int;

@export_category("Player Groups")
## The Teams of the player currently plays for both
@export var Club_Team: int;

## The National Team of the Player (array of eligable, in order of preference by player)
@export var National_Teams: Array[int]

## The Nationalities of the Player (array of territory ids)
@export var Nationalities: Array[int];


@export_category("Player Stats")

@export_subgroup("Stats Summary")
@export var Overall: int; #out of 100
@export var Potential: int; #out of 100

@export_subgroup("Technical Ability")
@export var Corners: int; #Set Pieces
@export var Crossing: int; #Corossing
@export var Dribbling: int; #Ball Control
@export var Finishing: int; #Shooting
@export var First_Touch: int; #Ball Control
@export var Free_Kicks: int; #Set Pieces
@export var Heading: int; # Aerial
@export var Long_Shots: int; #Shooting
@export var Long_Throws: int; #Throwing
@export var Marking: int; #Defending
@export var Passing: int; #Passing
@export var Penalties: int; #Set Pieces
@export var Tackling: int; #Defending
@export var Technique: int; #Crossing

@export_subgroup("Mental Ability")
@export var Aggression: int #Mentality
@export var Anticipation: int #Movement
@export var Bravery: int #Leadership
@export var Composure: int; #Final Third
@export var Concentration: int; #Mentality
@export var Decisions: int; #Movement
@export var Determination: int; #Strength
@export var Flair: int; #Final Third
@export var Leadership: int; #Leadership
@export var Off_The_Ball: int; #Movement
@export var Positioning: int; #Defending
@export var Teamwork: int; #Leadership
@export var Vision: int; #Passing
@export var Work_Rate: int; #Endurance

@export_subgroup("Physical Ability")
@export var Acceleration: int; #Speed
@export var Agility: int; #Speed
@export var Balance: int; #Strength
@export var Jumping: int; #Aerial
@export var Natural_Fitness: int; #Endurance
@export var Pace: int; #Speed
@export var Stamina: int; #Endurance
@export var Strength: int; #Strength
@export var Height: int; # in cms 
@export var Weight: int; # in Kgs


@export_category("Player History")
## The Overall Stats of All Seasons played by the player. The current season will be stored in
## position zero, and the bigger the index, the more years it was behind. 
@export var Previous_Seasons_Stats: Array[PlayerSeasonStats]

## The Stats for Previous Seasons for each tornament
@export var Previous_Tournament_Stats: Array[PlayerSeasonStats];

## Trophies Won
@export var Trophies_Won: Dictionary;

""" Method Functions """
## This is a constructor that allows us to initiate a Player with a name.
func _init(name := ""):
	Name = name;
	



""" Signal Functions """
func connect_signal(sig1: Signal, sig2: Signal) -> void:
	sig1.connect(_on_territory_id_changed);
	sig2.connect(_on_team_id_changed);

func _on_territory_id_changed(old_id: int, new_id: int) -> void:
	for index in range(Nationalities.size()):
		if Nationalities[index] == old_id:
			Nationalities[index] == new_id;
			return #There can only be once instance of each id, so return early now
			
func _on_team_id_changed(old_id: int, new_id: int) -> void:
	var club_id: int = Club_Team
	var national_id: Array[int] = National_Teams
	
	if club_id == old_id:
		Club_Team = new_id;
		return #There can only be once instance of each id, so return early now
		
	if old_id in national_id:
		National_Teams[national_id.find(old_id)] = new_id
		return #There can only be once instance of each id, so return early now
			
""" Loading and Saving Player Face """

## Function to save the image in the filesystem for the given player. Will save image with new identifier
func save_face_for_player(image: Image) -> bool:
	# First we need to validate that the image passed in is valid
	if image == null:
		return false;
		
	# Second, if team already has a logo saved, we need to ensure we delete it in order to ensure we don't leave unneeded images
	if Face_Path != null and not Face_Path.is_empty():
		DirAccess.remove_absolute(Face_Path_Dir + Face_Path)
	
	# Now we need to resize the image
	image.resize(120, 120, 2);
	
	# Now we need to save this image using the number unique identifier or previous name is already located
	var file_name: String =  uuid.v4() + ".png"
	var save_path: String = Face_Path_Dir + file_name;
	var error: Error = image.save_png(save_path);
	if error != OK:
		return false
	
	# Now we save this path inside of the terr to have forever. We will also use this path to delete the image
	Face_Path = file_name;
	return true

## Get the image for this team. Null is returned if no image exists for this Team
func get_player_face() -> Image:
	# Load Image
	if FileAccess.file_exists(Face_Path_Dir + Face_Path):
		var image: Image = Image.load_from_file(Face_Path_Dir + Face_Path)
		if image != null:
			return image
	
	
	return null
	

