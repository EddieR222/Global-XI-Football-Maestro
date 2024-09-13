extends Label


func display_player(player: Player) -> void:
	text = PlayerManager.convert_to_string_position(player.Club_Position);
