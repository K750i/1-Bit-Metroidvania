extends PowerUp



func _pickup() -> void:
	if player_stats.missiles != player_stats.max_missiles:
		player_stats.missiles_unlocked = true
		player_stats.missiles += 3
		queue_free()
