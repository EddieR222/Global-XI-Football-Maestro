class_name Staff
extends Resource
## The underlying resource class for all types of staff that can be hired by the player
##
## This is the underlying structure for all staff types in the Game. The functions and class fields here will be avaliable to all 
## staff types. Any Staff Specific functions or traits can be found in their respective Resource Files


""" Identifying Information """
## The Full Name of the Staff Member
@export var Name: String;

## This Field Contains the Staff ID of the Staff Member AND the Team ID of the Staff Member
## 1. Staff ID     Bits 0-31
## 2. Team ID      Bits 32-63
@export var Team_AND_Staff_ID: int; 

## The Enum that outlines all the Job Types for Staff
enum TITLES {
	MANAGER = 0,
	ASSISTANT_MANAGER = 1,
	FITNESS_COACH = 2,
	GOALKEEPER_COACH = 3,
	CHIEF_OF_STAFF = 4,
	STAFFING_MANAGER = 5,
	CHIEF_SCOUT = 6,
	SCOUT = 7,
	PERFORMANCE_ANALYST = 8,
	LOAN_MANAGER = 9,
	HEAD_PHYSIO = 10,
	PHYSIO = 11,
	BRANDING_DIRECTOR = 12,
	BRANDING_STAFF = 13,
	CHAIRMAN = 14,
	CEO = 15,
	DIRECTOR_OF_FOOTBALL = 16
}

## The Type of Staff. For example, Manager vs Youth Coach vs Medical etc
@export var Job_Title: TITLES;

## The age of the Staff Member
@export var Age: int; # 8 bits

## The Gender of the Staff Member
@export var Gender: int; #Either 0 or 1
# 1 bit

## The Nationality of the Staff Member (The ID of the territory)
@export var Nationalit_ID: int;
# 32 bit




""" Staff Ability """
#15 bits total

## The Management Capability of the Staff Member
@export var Management: int; #1 to 5 stars
# 3 bits
## The Coaching Capability of the Staff Member
@export var Coaching: int;

## The Scouting Capability of the Staff Member
@export var Scouting: int;

## The level of Leadership of the Staff Member
@export var Leadership: int;

## The Medical Knowledge of the Staff Member
@export var Medical: int;


""" Contract Info """

@export  


""" Setters """
func set_staff_id(id: int) -> bool:
	# Ensure ID is within range of unsigned 32 bit number
	if id < 0 or id > 4_294_967_295:
		return false
		
	# Get the bottom 32 bits
	var id_bits: int = id & 0xFFFFFFFF;
	
	# Now we clear the bits (in case we had a value previouslt) and then set bits
	Team_AND_Staff_ID &= ~(0xFFFFFFFF);
	Team_AND_Staff_ID |= (id_bits);
	return true
	
func set_team_id(id: int) -> bool:
	# Ensure ID is within range of unsigned 32 bit number
	if id < 0 or id > 4_294_967_295:
		return false
		
	# Get the bottom 32 bits
	var id_bits: int = id & 0xFFFFFFFF;
	
	# Now we clear the bits (in case we had a value previouslt) and then set bits
	Team_AND_Staff_ID &= ~(0xFFFFFFFF << 32);
	Team_AND_Staff_ID |= (id_bits << 32);
	return true


""" Getters """

