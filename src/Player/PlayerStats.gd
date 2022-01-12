extends Resource
class_name PlayerStats

var max_health := 5
var health := max_health setget set_health

signal health_changed(value)
signal died
signal add_screenshake

func set_health(value: int) -> void:
	if value < health:
		emit_signal("add_screenshake")
		
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
		
	if health == 0:
		emit_signal("died")



