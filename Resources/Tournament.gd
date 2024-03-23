class_name Tournament extends Resource


@export var Logo: Image;
@export var Name: String
@export var ID: int
@export var Importance: int
@export var Player_Team: int; 
@export var Num_Teams: int;
@export var Teams: Array[int];

@export var Host_Country_Name: String
@export var Host_Country_ID: int

@export var Every_N_Years: float;
@export var Start_Date: Array = []
@export var End_Date: Array = []

""" Qualification: How do teams qualify? """
@export var Qualifying_Tournaments: Array[QualificationSystem];

""" How do Teams """
@export var Disqualification: Array[QualificationSystem];

""" Tournament Stages """
@export var TournamentStages: Array[TournamentStage]

