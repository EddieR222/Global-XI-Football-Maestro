extends OptionButton


func tour_selected(t: Tournament) -> void:
	if t.Start_Date.is_empty():
		return
	select(t.Start_Date[0] - 1)
		

func clear_selection() -> void:
	select(-1);

