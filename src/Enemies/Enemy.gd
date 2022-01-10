extends KinematicBody2D

export var MAX_SPEED := 15

var motion := Vector2.ZERO


func _on_Hurtbox_hit(damage) -> void:
	queue_free()
