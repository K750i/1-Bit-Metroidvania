extends Node

export var max_health := 1
onready var health = max_health setget set_health

signal enemy_died


func set_health(value: int) -> void:
	health = value
	
	if health <= 0:
		emit_signal("enemy_died")
