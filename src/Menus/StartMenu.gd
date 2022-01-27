extends Control


func _ready() -> void:
	VisualServer.set_default_clear_color(Color.black)


func _on_NewGame_pressed() -> void:
	# warning-ignore-all:return_value_discarded
	get_tree().change_scene("res://src/World/World.tscn")


func _on_Continue_pressed() -> void:
	SaveAndLoad.is_loading = true
	get_tree().change_scene("res://src/World/World.tscn")


func _on_Quit_pressed() -> void:
	get_tree().quit()
