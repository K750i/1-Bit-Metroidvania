extends PowerUp



func _pickup() -> void:
	player_stats.missiles_unlocked = true
	queue_free()
