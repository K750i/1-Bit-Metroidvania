extends Node2D



func _ready() -> void:
	var parent := get_parent()
	if parent is MainWorld:
		parent.current_level = self


