extends SpinBox

func team_selected(team: Team) -> void:
	# Display it on LineEdit
	get_line_edit().text = str(team.Rating)

