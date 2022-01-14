extends Control


func _ready() -> void:
	VisualServer.set_default_clear_color(Color.black)


func _on_NewGame_pressed() -> void:
	get_tree().change_scene("res://src/World/World.tscn")


func _on_Continue_pressed() -> void:
	pass # Replace with function body.


func _on_Quit_pressed() -> void:
	get_tree().quit()
