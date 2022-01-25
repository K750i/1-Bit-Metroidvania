extends Area2D

var enabled = true

signal area_triggered



func _on_body_entered(body: Node) -> void:
	if enabled:
		emit_signal("area_triggered")
		enabled = false
