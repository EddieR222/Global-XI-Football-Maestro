class_name Confederation 
extends Resource
## The Class for storing information about the Confederations
##
## The Members here are for storing information and the functions are for updating or changing the information
## within this class. This class can be used to explore the entire world

@export_category("Identifying Information")

## The Name for this Confederation
@export
var Name: String;

## The unique ID number to identify this confederation. Most of the code should use this ID to work with confederations
@export
var ID: int;

## The Level of the Confederation. Only the World Confederation can be level 0, other additions by the user
## will all start at level 1 and build on top of that. 
@export
var Level: int;

## The List of Territories within this Confederation. We can use this to get the territories found within this Confederation
@export
var Territory_List: PackedInt32Array;

## The ID of the Confederation thats "owns" this confederation. In essence, this a nice way to store a ID pointer to the parent of this confederation
## There can only be one owner and if the value is -1, then it has no Owner
@export
var Owner_ID: int;

## The list of ID for the children confederations of this Confederation. This means this Confederation is the Owner of the Children here.
## This is a pointer ID to the Children of this Confederation, multiple children allowed
@export
var Children_ID: PackedInt32Array;

@export_category("Tournaments")

## The tournaments ID that are within this Confederation. Use this to access the Tournaments within this Confederation
@export
var Confed_Tournaments: PackedInt32Array

## The Tournament ID of the Super Cup for this Confederation
@export
var Super_Cup: int = -1

## DO NOT USE
@export var Cup: int = -1

@export_category("Rankings")

## The list of ID for all the National Teams within this Confederation. In additon, this list is sorted by the how strong each national team is
@export 
var National_Teams_Rankings: PackedInt32Array; #int = team_id

## The list of ID for the Leagues within this Confederation. In addition, this will be ranked by how strong the leagues are 
@export
var National_League_Rankings: PackedInt32Array; #int = tournament_id

## The list of IDs for the Club Teams within this Confederation. In addition, this will be ranked by how strong the club teams are.
@export
var Club_Teams_Rankings: PackedInt32Array; # int = team_id


""" Functions """
## Adds a new Territory to the list
func add_territory(id: int) -> void:
	# Id of territory should be positive
	if id < 0 or id >= Territory_List.size():
		return
		
	
	# Now we find the insert index of the id
	var insert_id: int = Territory_List.bsearch(id, true);
	
	# First, we check if value is already present
	if (Territory_List[insert_id] == id):
		return
	else:
		Territory_List.insert(insert_id, id);
		
	
func delete_territory(id: int) -> void:
	# Id of territory should be positive
	if id < 0 or id >= Territory_List.size():
		return 
		
	# Now we find the insert index of the id
	var remove_id: int = Territory_List.bsearch(id, true);
	
	# First, we check if value is already present
	if (Territory_List[remove_id] == id):
		Territory_List.remove_at(remove_id)
	


## Update the old territory id to the new one
func update_territory_id(old_id: int, new_id: int) -> void:
	# Get Index to Change
	var index_to_change: int = Territory_List.bsearch(old_id, true);
	
	# See that old id is present
	if (Territory_List[index_to_change] != old_id):
		return
	else:
		Territory_List.remove_at(index_to_change)
		
	var insert_id: int = Territory_List.bsearch(new_id, true);
	
	#Now we just insert
	Territory_List.insert(insert_id, new_id);
