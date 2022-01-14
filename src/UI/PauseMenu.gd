extends ColorRect
onready var scene_tree = get_tree()
var paused := false setget set_paused


func _on_Resume_pressed() -> void:
	self.paused = false


func _on_Quit_pressed() -> void:
	scene_tree.quit()


func set_paused(value: bool) -> void:
	paused = value
	visible = value
	scene_tree.paused = value


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		self.paused = not paused
	
	scene_tree.set_input_as_handled()
