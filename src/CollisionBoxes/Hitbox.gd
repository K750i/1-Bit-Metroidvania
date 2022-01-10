extends Area2D

const Explosion: PackedScene = preload("res://src/Effects/ExplosionEffect.tscn")
export var damage := 1


func _on_area_entered(hurtbox: Area2D) -> void:
	Utils.instance_scene_on_main(Explosion, owner.position)
	hurtbox.emit_signal("hit", damage)
	owner.queue_free()

