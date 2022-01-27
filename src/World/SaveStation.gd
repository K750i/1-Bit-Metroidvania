extends StaticBody2D

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var save_label: Label = $Label

var save_enabled := false



func _on_SaveArea_body_entered(_body: Node) -> void:
	save_enabled = true
	save_label.visible = true


func _on_SaveArea_body_exited(_body: Node) -> void:
	save_enabled = false
	save_label.visible = false


func _unhandled_input(event):
	if save_enabled and event is InputEventKey:
		if event.pressed and event.scancode == KEY_DOWN:
			anim_player.play("save")
			SaveAndLoad.save_game()






