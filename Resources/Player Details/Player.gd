class_name Player extends Resource

""" Identifying Information """
## The Name of the Player
@export var Name: String

## The Unique ID of the Player
@export var ID: int;


## The NickName of the Player
@export var NickName: String

## The BirthDate of the Player, stored as an array of integers in the (Month, Day, Year) format
@export var BirthDate: Array[int]

## The Age of the Player (in years)
@export var Age: int

## The Height of the Player (in cm)
@export var Height: int

## The Weight of the Player (in Kg)
@export var Weight: int

## The Nationalities of the Player (array of territory ids)
@export var Nationalities: Array[int]

## The Positions of the Player  (array of Positons Enums)
@export var Positions: Array[int]

## The Team ID of the team the player currently plays for
@export var Club_Team: int

## The Team ID of the National Team the player currently plays for (can't be changed after age 21)
@export var National_Team: int


""" Key Details """
## The Overall Rating of the Player
@export var Overall_Rating: int;

## The Potential of the Player
@export var Potential: int;

## The Market Value of the Player (in US Dollars, either in Millions or Thousands
@export var Market_Value: float

## The Multiplier for the Market Value (either 1,000,000 or 1,000)
@export var Multiplier: int;

## The Weekly Wage the Player is Earning (always in thousands of US Dollars)
@export var Wage: int

## The Preferred Foot by the Player (0 = right, 1 = left, 2 = both)
@export var Preferred_Foot: int

## The Stars the Player has in Skill Moves
@export var Skill_Moves: int

## The Stars the PLayer has in Weak Foot (if 5 then player's preferred foot will become both)
@export var Weak_Foot: int;

## Current Player Morale, how motivated or happy is the player. 
## The BreakDown of the Morale is as follows
## 1. Morale > 90  Very Happy
## 2. Morale > 75  Happy
## 3. Morale > 25  Neutral
## 4. Morale < 25  UnHappy
## 5. Morale < 10  Very UnHappy
@export var Morale: int

## The current training results; Higher the number the harder and better the player is training
@export var Training: int

## The current Sharpness of the Player.
## The BreakDown of the Sharpness is as follows
## 1. Sharpness > 90  Very Fit
## 2. Sharpness > 75  Fit
## 3. Sharpness > 25  Neutral
## 4. Sharpness < 25  UnFit
## 5. Sharpness < 10  Very UnFit
@export var Sharpness: int


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

