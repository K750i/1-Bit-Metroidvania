extends Node2D



func _ready() -> void:
	var parent := get_parent()
	if parent is MainWorld:
		parent.current_level = self


func save() -> Dictionary:
	return {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"position_x": position.x,
		"position_y": position.y,
	}
