extends LineEdit


func tour_selected(t: Tournament) -> void:
	text = t.Name

func clear_selection() -> void:
	text = "New Tournament"
