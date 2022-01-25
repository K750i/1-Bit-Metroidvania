extends Resource
class_name PlayerStats

var max_health := 5
var health := max_health setget set_health
var max_missiles := 6
var missiles = 0 setget set_missiles
var missiles_unlocked := false setget set_missiles_unlocked

signal health_changed(value)
signal missiles_changed(value)
signal missiles_unlocked(value)
signal died
signal add_screenshake


func set_health(value: int) -> void:
	if value < health:
		emit_signal("add_screenshake")
		
	health = int(clamp(value, 0, max_health))
	emit_signal("health_changed", health)
		
	if health == 0:
		emit_signal("died")


func set_missiles(value: int) -> void:
	missiles = clamp(value, 0, max_missiles)
	emit_signal("missiles_changed", missiles)


func set_missiles_unlocked(value: bool) -> void:
	missiles_unlocked = value
	emit_signal("missiles_unlocked", missiles_unlocked)
