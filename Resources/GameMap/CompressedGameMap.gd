class_name CompressedGameMap
extends Resource

## The FileName Decided on in the World Editor
@export var Filename: String:
	get: return Filename;
	set(name): Filename = name;
	
@export_category("World Map")
## The Array that contains all Confederations. 
@export var Confederations: Array[Confederation] = [];

