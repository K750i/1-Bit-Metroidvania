extends Node2D

const Explosion: PackedScene = preload("res://src/Effects/ExplosionEffect.tscn")
var velocity := Vector2.ZERO


func _process(delta: float) -> void:
	position += velocity * delta


func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	queue_free()


func _on_Hitbox_body_entered(_body: Node) -> void:
	Utils.instance_scene_on_main(Explosion, position)
	queue_free()	
