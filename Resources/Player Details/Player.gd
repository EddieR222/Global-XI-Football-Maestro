class_name Player extends Resource

""" Identifying Information """

## The Unique ID of the Player
@export var ID: int;

## The Name of the Player
@export var Name: String

## The NickName of the Player
@export var NickName: String

## The BirthDate of the Player, stored as an array of integers in the (Month, Day, Year) format
@export var BirthDate: Array[int];

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
@export var Nationalities: Array[int]

## The Positions of the Player  (array of Positons Enums)
@export var Positions: Array[int]

## The Team ID of the team the player currently plays for
@export var Club_Team: int

## The Team ID of the National Team the player currently plays for (can't be changed after age 21)
@export var National_Team: int


""" Key Details """
## The Market Value of the Player (in US Dollars, either in Millions or Thousands
@export var Market_Value: float

## The Multiplier for the Market Value (either 1,000,000 or 1,000)
@export var Multiplier: int;

## The Weekly Wage the Player is Earning (always in thousands of US Dollars)
@export var Wage: int




## The current training results; Higher the number the harder and better the player is training
@export var Training: int

## This details if the player is healthy = 1, injured = 2, or injury prone = 3
@export var Condition: int

## The Specific Injury if has any
@export var Injury: String

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

## Sets the Player's Age, must below 150
func set_player_age(age: int) -> void:
	# Return early if age is invalid
	if age >= 150 or age < 0:
		return
		
	# Now we set it but first we have to manipulate the bits
	var age_bits: int = age & 0xFF;
	
	# Now we set the bits
	Key_Details |= age_bits;

## Sets the Player Height, must be below 255 or above 0
func set_player_height(height: int) -> void:
	# Return early if height is invalid
	if height >= 255 or height < 0:
		return
		
	# Now we set it but first we have to manipulate the bits
	var height_bits: int = height & 0xFF;
	
	# Now we set the bits
	Key_Details |= (height_bits << 8);
