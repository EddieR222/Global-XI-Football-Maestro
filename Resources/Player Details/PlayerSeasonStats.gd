class_name  PlayerSeasonStats extends Resource

""" Season Details """
## The Team Played for this Season
@export var Team_ID: PackedInt32Array

## The Season
##Starting year
@export var Starting_Year: int
@export var End_Year: int


## The Tournament That was Played, if -1 then we know this is the overall stats for the entire season over all tournaments
@export var Tournament_ID: int

@export_category("Overall")
## The Number of Games Played (aka Caps)
@export var Appearances: int

## The Average Match Rating
@export var Match_Rating: float;

## Number of times the player won Player of the Match
@export var Player_Of_The_Matches: int;

# INFO Defensive Stats
@export_category("Defensive Stats")

## The Number of Tackles Attempted
@export var Tackles_Attempted: int

## The Number of Successful Tackles
@export var Tackles_Won: int;

## The Number of Attempted Slide Tackles
@export var Slide_Tackles_Attempted: int

## The Number of Successful Slide Tackles
@export var Slide_Tackles_Won: int;

## The Number of Interceptions
@export var Interceptions: int

## The Number of Clearences
@export var Clearences: int

## The Number of Blocked Shots
@export var Blocked_Shots: int

## The Number of Yellow Cards
@export var Yellows: int;

## The Number of Red Cars:
@export var Reds: int;

## The Number of Fouls Commited
@export var Fouls: int;

# INFO Game Control or Passing Stats
@export_category("Game Control Stats")

## The Number of Touches
@export var Touches: int;

## The Number of Attempted Passes
@export var Passes_Attempted: int

## The Number of Successful Passes
@export var Passes_Completed: int

## The Number of Key Passes
@export var Key_Passes: int

## The Number of Attempted Crosses
@export var Crosses_Attempted: int;

## The Number of Successful Crosses
@export var Crosses_Completed: int;

## The Number of Through Balls Attempted
@export var Through_Balls_Attempted: int;

## The Number of Successful Through Balls
@export var Through_Balls_Completed: int;

## The Number of Times the Player Lost the Ball (aka Dispossessions)
@export var Dispossessions: int;

# INFO Offensive Stats
@export_category("Offensive Stats")
## The Number of Shots Attempted
@export var Shots_Attempted: int;

## The Number of Shots ON Target
@export var Shots_On_Target: int

## The Number of Aerials Won
@export var Aerials_Won: int;

## The Number of Assists
@export var Assists: int;

## The Number of Goals
@export var Goals: int;

## The XG (expectd goals) for the player this season
@export var Expected_Goals: float

## The Number of Times the Player was Offside
@export var Offsides: int;

## The Number of Penalties Taken
@export var Penalties_Attempted: int

## The Number of Penalties Scored
@export var Penalties_Complete: int

