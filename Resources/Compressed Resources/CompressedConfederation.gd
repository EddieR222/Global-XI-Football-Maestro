class_name CompressedConfederation
extends Resource
## The Class for saving and loading the Confederation. This Resource is the Compressed version of the Resource Confederation
##
## The fields here are compressed fields of Confederation and should not be used directly in other sections of code 
## (besides compressing and decompressing Confederations). The comments tell you what each field contains and what bits are what




@export_category("Identifying Information")

## The Name for this Confederation
@export var Name: String;

## The List of Territories within this Confederation. We can use this to get the territories found within this Confederation
## Since Resources are ref counted, these will be converted to pure pointers when saved and compressed
@export
var Territory_List: Array[CompressedTerritory];

## The list of ID for the children confederations of this Confederation. This means this Confederation is the Owner of the Children here.
## Since Resources are ref counted, these will be converted to pure pointers when saved and compressed
@export
var Children: Array[CompressedConfederation];

## This field will contain the following
## 1. ID:    Bits [0-31]
## 2. Owner: Bits [32 - 63]
@export var field_1: int;



@export_category("Tournaments")
## The tournaments ID that are within this Confederation. Use this to access the Tournaments within this Confederation
## Since Resources are ref counted, these will be converted to pure pointers when saved and compressed
@export
var Tournaments: Array[CompressedTournament];

## This field will contain the following
## 1. Super_Cup ID:     Bits [0-31]
## 2. Top Domestic Cup: Bits [32 - 63]
@export var field_2: int;

## The list of ID for the Leagues within this Confederation. In addition, this will be ranked by how strong the leagues are 
@export
var League_Rankings: Array[CompressedTournament];


@export_category("Team Rankings")

## The list of ID for all the National Teams within this Confederation. In additon, this list is sorted by the how strong each national team is
@export 
var National_Teams_Rankings: Array[CompressedTeam];

## The list of IDs for the Club Teams within this Confederation. In addition, this will be ranked by how strong the club teams are.
@export
var Club_Teams_Rankings: Array[CompressedTeam];

# CRITICAL Still Missing Level number


""" Setter Functions """
func _set_name(name: String) -> bool:
	if name.length() < 2:
		return false
	Name = name;
	return true
	
func _set_id(id: int) -> bool:
	# Return early if age is invalid
	if id < -1 or id >= 0xFFFFFFFF:
		return false
		
	# Now we set it but first we have to manipulate the bits
	var id_bits: int;
	if id == -1:
		id_bits = 0xFFFFFFFF
	else: 
		id_bits = id & 0xFFFFFFFF;
	
	# Now we set the bits
	field_1 &= ~(0xFFFFFFFF);
	field_1 |= id_bits;
	return true

func _set_owner(id: int) -> bool:
	# Return early if age is invalid
	if id < -1 or id >= 0xFFFFFFFF:
		return false
		
	# Now we set it but first we have to manipulate the bits
	var id_bits: int;
	if id == -1:
		id_bits = 0xFFFFFFFF
	else: 
		id_bits = id & 0xFFFFFFFF;
	
	# Now we set the bits
	field_1 &= ~(0xFFFFFFFF << 32);
	field_1 |= id_bits << 32;
	return true

func _set_territory_list(list: Array[CompressedTerritory]) -> bool:
	Territory_List = list;
	return true
	
func _set_children(list: Array[CompressedConfederation]) -> bool:
	Children = list;
	return true	
	
func _set_confed_tournaments(list: Array[CompressedTournament]) -> bool:
	Tournaments = list;
	return true;
	
func _set_super_cup(id: int) -> bool:
	# Return early if age is invalid
	if id < -1 or id >= 0xFFFFFFFF:
		return false
		
	# Now we set it but first we have to manipulate the bits
	var id_bits: int;
	if id == -1:
		id_bits = 0xFFFFFFFF
	else: 
		id_bits = id & 0xFFFFFFFF;
	
	# Now we set the bits
	field_2 &= ~(0xFFFFFFFF);
	field_2 |= id_bits;
	return true
	
func _set_domestic_cup(id: int) -> bool:
	# Return early if age is invalid
	if id < -1 or id >= 0xFFFFFFFF:
		return false
		
	# Now we set it but first we have to manipulate the bits
	var id_bits: int;
	if id == -1:
		id_bits = 0xFFFFFFFF
	else: 
		id_bits = id & 0xFFFFFFFF;
	
	# Now we set the bits
	field_2 &= ~(0xFFFFFFFF << 32);
	field_2 |= id_bits << 32;
	return true
	
func _set_league_ranking(list: Array[CompressedTournament]) -> bool:
	League_Rankings = list;
	return true
	
func _set_national_team_rankings(list: Array[CompressedTeam]) -> bool:
	National_Teams_Rankings = list;
	return true;
	
func _set_club_team_rankings(list: Array[CompressedTeam]) -> bool:
	Club_Teams_Rankings = list;
	return true;
	
""" Getter Functions """

func _get_name() -> String:
	return Name

func _get_id() -> int:
	# Handle Special Case
	var id: int = field_1 & 0xFFFFFFFF;
	
	if id == 0xFFFFFFFF:
		return -1;
	return id;
	
func _get_owner() -> int:
	# Handle Special Case
	var id: int = (field_1 >> 32) & 0xFFFFFFFF;
	
	if id == 0xFFFFFFFF:
		return -1;
	return id;

func _get_territory_list() -> Array[CompressedTerritory]:
	return Territory_List

func _get_children() -> Array[CompressedConfederation]:
	return Children;
	
func _get_confed_tournaments() -> Array[CompressedTournament]:
	return Tournaments
	
func _get_super_cup() -> int:
	# Handle Special Case
	var id: int = field_2 & 0xFFFFFFFF;
	
	if id == 0xFFFFFFFF:
		return -1;
	return id;

func _get_domestic_cup() -> int:
	# Handle Special Case
	var id: int = field_2 & 0xFFFFFFFF;
	
	if id == 0xFFFFFFFF:
		return -1;
	return id;

func _get_league_ranking() -> Array[CompressedTournament]:
	return League_Rankings

func _get_national_team_rankings() -> Array[CompressedTeam]:
	return National_Teams_Rankings;
	
func _get_club_team_rankings() -> Array[CompressedTeam]:
	return Club_Teams_Rankings
