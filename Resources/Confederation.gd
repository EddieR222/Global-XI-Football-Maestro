class_name Confederation 
extends Resource
## The Class for storing information about the Confederations
##
## The Members here are for storing information and the functions are for updating or changing the information
## within this class. This class can be used to explore the entire world




@export_category("Identifying Information")

## The Name for this Confederation
@export
var Name: String:
	get: return Name
	set(name): 
		if name.length() < 2:
			return
		else:
			Name = name;

## The unique ID number to identify this confederation. Most of the code should use this ID to work with confederations
@export
var ID: int:
	get: return ID;
	set(new_id): 
		ID = new_id;

## The Level of the Confederation. Only the World Confederation can be level 0, other additions by the user
## will all start at level 1 and build on top of that. 
@export
var Level: int;

## The List of Territories within this Confederation. We can use this to get the territories found within this Confederation
@export
var Territory_List: Array[Territory];

## The owner of this confederation, is not a refernce as this would create a cyclic reference, instead we use the int ID (weak ref of sorts) to point up
@export
var Owner: int;


## The list of ID for the children confederations of this Confederation. This means this Confederation is the Owner of the Children here.
## This is a pointer ID to the Children of this Confederation, multiple children allowed
@export
var Children: Array[Confederation];

@export_category("Tournaments")
## The tournaments ID that are within this Confederation. Use this to access the Tournaments within this Confederation
@export
var Confed_Tournaments: Array[Tournament];

## The Tournament ID of the Super Cup for this Confederation
@export
var Super_Cup: int = -1

## DO NOT USE
@export var Cup: int = -1

@export_category("Rankings")

## The list of ID for all the National Teams within this Confederation. In additon, this list is sorted by the how strong each national team is
@export 
var National_Teams_Rankings: Array[Team];

## The list of ID for the Leagues within this Confederation. In addition, this will be ranked by how strong the leagues are 
@export
var National_League_Rankings: Array[Tournament];

## The list of IDs for the Club Teams within this Confederation. In addition, this will be ranked by how strong the club teams are.
@export
var Club_Teams_Rankings: Array[Team];


""" Functions """
## Adds a new Territory to the list local to the Confederation
func add_territory(terr: Territory) -> void:
	# First we validate
	if terr.Name.is_empty():
		return 
		
	# Now we can add it to the list
	Territory_List.append(terr);
	
	# Sort them by alphabetical order
	Territory_List.sort_custom(func(a: Territory, b: Territory): return a.Name.to_lower() < b.Name.to_lower());
	
		
	
func delete_territory(terr: Territory) -> void:
	Territory_List.erase(terr);
	
	
""" Signals """
func connect_signal(sig: Signal) -> void:
	sig.connect(_on_id_changed)
	
func _on_id_changed(old_id: int, new_id: int) -> void:
	if Owner == old_id:
		Owner = new_id;
		LogDuck.d("Owner ID of {name} changed from {old} -> {new}".format({"name": Name, "old": old_id, "new": new_id}));
	if ID == old_id:
		ID = new_id;
		LogDuck.d("ID of {name} changed from {old} -> {new}".format({"name": Name, "old": old_id, "new": new_id}));
	

