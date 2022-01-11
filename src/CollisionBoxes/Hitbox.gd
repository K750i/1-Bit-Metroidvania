extends Area2D

export var damage := 1


func _on_area_entered(hurtbox: Area2D) -> void:
	hurtbox.emit_signal("hit", damage)


