class_name Player extends Resource

""" Identifying Information """

## The Unique ID of the Player
@export var ID: int; #64 bits

## The Name of the Player
@export var Name: String

## The Path for the Player's Face Image
@export var Face_Path: String;

## The NickName of the Player
@export var NickName: String

## The BirthDate of the Player, stored as an integer in the (Month, Day, Year) format
## Month:      Bits 0-3   (month 1-12)
## Day:        Bits 4-11  (day 1-31)
## Year:       Bits 12-61 (year)
@export var BirthDate: int;

## This contains a large amount of key details of the player.[br]
## Every 8 bits contain different info about the player.[br]
## Age:        Bits 0-7   (in years)[br]
## Height:     Bits 8-15  (in cm)[br]
## Weight:     Bits 16-23 (in kg)[br]
## Rating:     Bits 24-31 (overall rating)[br]
## Potential:  Bits 32-39 (potential)[br]
## Foot:       Bits 40 (0= right, 1 = left)[br]
## Skill Move: Bits 41-43 (1-5 stars)[br]
## Weak Foot:  Bits 44-46 (1-5 stars)[br]
## Morale:     Bits 47-54 (morale)[br]
## Current Player Morale, how motivated or happy is the player. 
## The BreakDown of the Morale is as follows
## 1. Morale > 90  Very Happy
## 2. Morale > 75  Happy
## 3. Morale > 25  Neutral
## 4. Morale < 25  UnHappy
## 5. Morale < 10  Very UnHappy
## Sharpness:  Bits 55-62 (sharpness)[br]
## The current Sharpness of the Player.
## The BreakDown of the Sharpness is as follows
## 1. Sharpness > 90  Very Fit
## 2. Sharpness > 75  Fit
## 3. Sharpness > 25  Neutral
## 4. Sharpness < 25  UnFit
## 5. Sharpness < 10  Very UnFit
@export
var Key_Details: int = 0;


## The Nationalities of the Player (array of territory ids)
@export var Nationalities: PackedInt32Array;

## The Positions of the Player  (array of Positons Enums)
## Every 8 bits will be a new position (8 bits means that position will be a variant of 255 positions)
## For a total of 8 positions possible per player (most will have 1, 2, 3)
@export var Positions: int

## The Team ID of the team the player currently plays for both
## First 32 bits are the Club Team
## Last 32 bits are the National Team
@export
var Team_IDs: int


""" Key Details """
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

""" Current Season Stats """
## The Class that Contains all the Stats for the Current Season
@export var Overall_Season_Stats: PlayerSeasonStats

## The Stats for Each Individal Tournaments
@export var Tournament_Stats: Array[PlayerSeasonStats]

""" Player History """
## The Overall Stats of Previous Seaons
@export var Previous_Seasons_Stats: Array[PlayerSeasonStats]

## The Stats for Previous Seasons for each tornament
@export var Previous_Tournament_Stats: Array[PlayerSeasonStats];

## Trophies Won
@export var Trophies_Won: Dictionary;


""" Player Setter Functions """
## Call to set Player Name. String must be greater than 1 in length
func set_player_name(name: String) -> void:
	if name.length() <= 1:
		return
		
	Name = name;

## Sets the Player's ID
func set_player_id(id: int) -> void:
	ID = id;

## Sets the Player's Birthdate
func set_player_birthdate(month:int, day:int, year:int) -> void:
	# Set the Month 
	var month_bits:int = month & 0xF;
	BirthDate &= ~(0xF);
	BirthDate |= month_bits;
	
	# Set the Day
	var day_bits: int = day & 0xFF;
	BirthDate &= ~(0xFF << 4);
	BirthDate |= (day_bits << 4);
	
	# Set the Year
	var year_bits: int = year & 0xFFFFFFFFFFFFF;
	BirthDate &= ~(0xFFFFFFFFFFFFF << 12);
	BirthDate |= (year_bits << 12);

## Sets the Player's Age, must below 150
func set_player_age(age: int) -> void:
	# Return early if age is invalid
	if age >= 150 or age < 0:
		return
		
	# Now we set it but first we have to manipulate the bits
	var age_bits: int = age & 0xFF;
	
	# Now we set the bits
	Key_Details &= ~(0xFF);
	Key_Details |= age_bits;

## Sets the Player Height, must be below 255 or above 0
func set_player_height(height: int) -> void:
	# Return early if height is invalid
	if height >= 255 or height < 0:
		return
		
	# Now we set it but first we have to manipulate the bits
	var height_bits: int = height & 0xFF;
	
	# Now we set the bits
	Key_Details &= ~(0xFF << 8);
	Key_Details |= (height_bits << 8);
	
## Sets the Player Weight, must be below 255 (kg) or above 0
func set_player_weight(weight: int) -> void:
	# Return early if height is invalid
	if weight >= 255 or weight < 0:
		return
		
	# Now we set it but first we have to manipulate the bits
	var weight_bits: int = weight & 0xFF;
	
	# Now we set the bits
	Key_Details &= ~(0xFF << 16);
	Key_Details |= (weight_bits << 16);
	
## Sets the Player Overall Rating, must be a value in between 1 and 99 (no 100 allowed)
func set_player_overall_rating(rating: int) -> void:
	# Return early if height is invalid
	if rating > 99 or rating < 1:
		return
		
	# Now we set it but first we have to manipulate the bits
	var rating_bits: int = rating & 0xFF;
	
	# Now we set the bits
	Key_Details &= ~(0xFF << 24);
	Key_Details |= (rating_bits << 24);
	
## Sets the Player's Potential Rating, must be a value between 1 and 99 (no 100 or 0 allowed)
func set_player_potential_rating(rating: int) -> void:
	# Return early if height is invalid
	if rating > 99 or rating < 1:
		return
		
	# Now we set it but first we have to manipulate the bits
	var rating_bits: int = rating & 0xFF;
	
	# Now we set the bits
	Key_Details &= ~(0xFF << 32);
	Key_Details |= (rating_bits << 32);
	
## Sets the player's preferred foot (either right or left)
func set_player_foot(right: bool) -> void:
	if right:
		Key_Details |= (0x1 << 40); #sets bit to one (meaning right)
	else:
		Key_Details &= ~(0b1 << 40); # sets it to zero (meaning left)

## Sets the player's skill moves (1 - 5 stars)
func set_player_skill_moves(stars: int) -> void:
	# Return early if height is invalid
	if stars > 5 or stars < 1:
		return
		
	# Now we set it but first we have to manipulate the bits
	var star_bits: int = stars & 0b111;
	
	# Now we set the bits
	Key_Details &= ~(0b111 << 40);
	Key_Details |= (star_bits << 40);
	
## Sets the player's Weak Foot (1 - 5 stars)
func set_player_weak_foot(stars: int) -> void:
	# Return early if height is invalid
	if stars > 5 or stars < 1:
		return
		
	# Now we set it but first we have to manipulate the bits
	var star_bits: int = stars & 0b111;
	
	# Now we set the bits
	Key_Details &= ~(0b111 << 44);
	Key_Details |= (star_bits << 44);
	
## Sets the player's morale. Must be between 1 and 99
func set_player_morale(morale: int) -> void:
	# Return early if height is invalid
	if morale > 99 or morale < 1:
		return
		
	# Now we set it but first we have to manipulate the bits
	var morale_bits: int = morale & 0xFF;
	
	# Now we set the bits
	Key_Details &= ~(0xFF << 47);
	Key_Details |= (morale_bits << 47);
	
## Sets the player's sharpness Must be between 1 and 99
func set_player_sharpness(sharpness: int) -> void:
	# Return early if height is invalid
	if sharpness > 99 or sharpness < 1:
		return
		
	# Now we set it but first we have to manipulate the bits
	var sharpness_bits: int = sharpness & 0xFF;
	
	# Now we set the bits
	Key_Details &= ~(0xFF << 55);
	Key_Details |= (sharpness_bits << 55);

## Adds a Nationality to the list of Nationalities
func add_player_nationality(terr_id: int) -> void:
	# Since we don't have data about the territories here, we simply add it
	Nationalities.append(terr_id);

## Sets the positions of the player given by the Position Number
func set_players_positions(positions: Array[int]) -> void:
	for iter in range(8):
		# Get position
		var curr_position: int = positions[iter];
		
		# Ready by masking
		var pos_bits: int = curr_position & 0xFF;
		
		# Set the bits
		Positions &= ~(0xFF << (iter * 8));
		Positions |= (pos_bits << (iter * 8) );

## Sets the player's club team by saving team_id of club
func set_player_club_team(team_id: int) -> void:
	# Get Bits Ready
	var team_bits: int = team_id & 0xFFFFFFFF;
	
	# Set the bits
	Team_IDs &= ~(0xFFFFFFFF);
	Team_IDs |= team_bits;
	
## Sets the player's club team by saving team_id of club
func set_player_national_team(team_id: int) -> void:
	# Get Bits Ready
	var team_bits: int = team_id & 0xFFFFFFFF;
	
	# Set the bits
	Team_IDs &= ~(0xFFFFFFFF << 32);
	Team_IDs |= (team_bits << 32);

## Sets the market value of the player
func set_player_market_value(value: float) -> void:
	if value < 0:
		return
		
	Market_Value = value;

## Sets the Wage of the player
func set_player_wage(wage: float) -> void:
	if wage < 0:
		return
		
	Wage = wage;
	
## Sets the player training result number	
func set_player_training(result: int) -> void:
	if result < 0 or result > 100:
		return
		
	Training = result;

## Set the player's condition
func set_player_condition(cond: int) -> void:
	if cond < 0 or cond > 2:
		return
		
	Condition = cond;
	
# Set the Player's Injury ID
func set_player_injury(injury_id: int) -> void:
	if injury_id < 0:
		return
		
	Injury = injury_id;
	
## Set the player's month injured
func set_player_month_injured(months: float) -> void:
	if months < 0:
		return
		
	Months_Injured = months;


""" Getter Functions """
## Call to get Player Name
func get_player_name() -> String: return Name;

## Gets the Player's ID
func get_player_id() -> int: return ID

## Gets the Player's Birthdate Day
func get_player_birth_day() -> int: return (BirthDate >> 4) & 0xFF;

## Gets the Player's Birthdate Month
func get_player_birth_month() -> int: return (BirthDate & 0xF);

## Gets the Player's Birthdate Year
func get_player_birth_year() -> int: return (BirthDate >> 12) & 0xFFFFFFFFFFFFF;

## Sets the Player's Age
func get_player_age() -> int: return Key_Details & 0xFF;
	
## Gets the Player Height
func get_player_height() -> int: return (Key_Details >> 8) & 0xFF;

## Gets the Player Weight
func get_player_weight() -> int: return (Key_Details >> 16) & 0xFF;

## Gets the Player Overall Rating
func get_player_overall_rating() -> int: return (Key_Details >> 24) & 0xFF; 

## Gets the Player's Potential Rating
func get_player_potential_rating() -> int: return (Key_Details >> 32) & 0xFF;

## Gets the player's preferred foot (either right or left)
func get_player_foot() -> bool: return ((Key_Details >> 40) & 0b1) == 0b1;

## Gets the player's skill moves (1 - 5 stars)
func get_player_skill_moves() -> int: return (Key_Details >> 41) & 0b111;

## Gets the player's Weak Foot (1 - 5 stars)
func get_player_weak_foot() -> int: return (Key_Details >> 44) & 0b111;

## Gets the player's morale. 
func get_player_morale() -> int: return (Key_Details >> 47) & 0xFF;

## Gets the player's sharpness 
func get_player_sharpness() -> int: return (Key_Details >> 55) & 0xFF;

## Gets the list of player's nationalities
func get_player_nationalities() -> PackedInt32Array: return Nationalities;

## Gets the positions of the player given by the Position Number
func get_player_positions() -> int: return Positions;

## Gets the player's club team ID
func get_player_club_team() -> int: return (Team_IDs & 0xFFFFFFFF);

## Gets the player's national team ID
func get_player_national_team() -> int: return (Team_IDs >> 32) & 0xFFFFFFFF;

## Gets the market value of the player
func get_player_market_value() -> float: return Market_Value;

## Gets the Wage of the player
func get_player_wage() -> float: return Wage;

## Gets the player training result number	
func get_player_training() -> int: return Training;

## Get the player's condition
func get_player_condition() -> int: return Condition;

# Get the Player's Injury ID
func get_player_injury() -> int: return Injury;

## Get the player's month injured
func get_player_month_injured() -> float: return Months_Injured;


