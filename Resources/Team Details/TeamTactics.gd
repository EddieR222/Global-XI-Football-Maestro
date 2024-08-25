class_name TeamTactics
extends Resource




@export_category("Team Formations")
## The overall formation of the team. ALl attacking and defense build off of this central formation
@export var Formation: String

## The Positions of the Formation
@export var Position_Names: Array[String];
@export var Position_Points: Array[Vector2];


