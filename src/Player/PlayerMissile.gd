extends "res://src/Player/Projectile.gd"

const EnemyDeathEffect: PackedScene = preload("res://src/Effects/EnemyDeathEffect.tscn")
const BRICK_BIT_LAYER = 4

func _ready() -> void:
	$Flames.emitting = true


func _on_Hitbox_body_entered(body: Node) -> void:
	._on_Hitbox_body_entered(body)
	if body.get_collision_layer_bit(BRICK_BIT_LAYER):
		# warning-ignore:return_value_discarded
		Utils.instance_scene_on_main(EnemyDeathEffect, body.position + Vector2(8, 8))
		body.queue_free()




