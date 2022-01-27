extends KinematicBody2D

const EnemyDeathEffect: PackedScene = preload("res://src/Effects/EnemyDeathEffect.tscn")

export var MAX_SPEED := 15

onready var stats: Node = $EnemyStats
var motion := Vector2.ZERO


func _on_Hurtbox_hit(damage: int) -> void:
	stats.health -= damage


func _on_EnemyStats_enemy_died() -> void:
	queue_free()


func _exit_tree() -> void:
	# warning-ignore-all:return_value_discarded
	Utils.instance_scene_on_main(EnemyDeathEffect, position)
