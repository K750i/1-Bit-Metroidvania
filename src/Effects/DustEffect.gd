extends Node2D

var velocity := Vector2(rand_range(20, 20), rand_range(-20, -10))

func _process(delta: float) -> void:
	position += velocity * delta
