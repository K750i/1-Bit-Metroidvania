extends Node2D

const Explosion: PackedScene = preload("res://src/Effects/ExplosionEffect.tscn")
var velocity := Vector2.ZERO


# colliding with walls
# warning-ignore:unused_argument
func _on_Hitbox_body_entered(body: Node) -> void:
	# warning-ignore-all:return_value_discarded
	Utils.instance_scene_on_main(Explosion, position)
	queue_free()	


# colliding with enemies
# warning-ignore:unused_argument
func _on_Hitbox_area_entered(area: Area2D) -> void:
	Utils.instance_scene_on_main(Explosion, position)
	queue_free()
	
	
func _process(delta: float) -> void:
	position += velocity * delta


func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	queue_free()


