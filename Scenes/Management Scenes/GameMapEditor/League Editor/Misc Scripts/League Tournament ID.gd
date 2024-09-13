extends Label

func league_selected(t: Tournament) -> void:
	text = "ID: " + str(t.ID)


func clear_selection() -> void:
	text = "ID: "
