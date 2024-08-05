class_name TeamTournamentStats
extends Resource





## The number of matches played in the tournament
## CRITICAL Maximum of 255 matches


## The following number stores the following details about the team
## Number Games Played:        Bits 0-7   (in years)[br] CRITICAL 255 matches max
## Height:     Bits 8-15  (in cm)[br]
## Weight:     Bits 16-23 (in kg)[br]
## Rating:     Bits 24-31 (overall rating)[br]
## Potential:  Bits 32-39 (potential)[br]
## Foot:       Bits 40 (0= right, 1 = left)[br]
## Skill Move: Bits 41-43 (1-5 stars)[br]
## Weak Foot:  Bits 44-46 (1-5 stars)[br]
## Morale:     Bits 47-54 (morale)[br]
@export var Key_Details: int


@export var Games_Played: int;
@export var Wins: int;
@export var Draws: int;
@export var Losts: int;
@export var Goals_For: int;
@export var Goals_Against: int;
@export var Goals_Diff: int;
@export var Points: int;
@export var Form: Array[int];
@export var Yellow_Cards: int;
@export var Red_Cards: int;
