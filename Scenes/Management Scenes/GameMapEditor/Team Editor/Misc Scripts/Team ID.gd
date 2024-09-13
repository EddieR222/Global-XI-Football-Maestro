extends Label

func team_selected(team: Team) -> void:
	# Display it on Label
	text = "ID: " + str(team.ID)
