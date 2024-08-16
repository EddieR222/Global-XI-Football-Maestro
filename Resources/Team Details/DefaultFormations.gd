class_name DefaultFormations
extends Resource



var formations: Dictionary = {
	"2-3-5": [
		Vector2(), # Goalkeeper
		Vector2(), # Left CB
		Vector2(), # Right CB 
		Vector2(), # Left CM
		Vector2(), # Mid CM
		Vector2(), # Right CM
		Vector2(), # LW
		Vector2(), # Left CF
		Vector2(), # Striker
		Vector2(), # Right CF
		Vector2() # RW
	],
	"4-4-2": [
		Vector2(50,95), # Goalkeeper
		Vector2(10,80), # LB
		Vector2(35,80), # Left CB
		Vector2(65,80), # Right CB
		Vector2(90, 80), # RB
		Vector2(10,50), # LM
		Vector2(35,50), # CM
		Vector2(65,50), # CM
		Vector2(90, 50), # RM
		Vector2(35,8), # Striker
		Vector2(65,8) # Striker
	]
}
