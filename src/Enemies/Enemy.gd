extends KinematicBody2D

export var MAX_SPEED := 15

onready var stats: Node = $EnemyStats
var motion := Vector2.ZERO


func _on_Hurtbox_hit(damage: int) -> void:
	stats.health -= damage


func _on_EnemyStats_enemy_died() -> void:
	queue_free()
