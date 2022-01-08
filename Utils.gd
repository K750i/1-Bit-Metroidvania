extends Node

func instance_scene_on_main(scene: PackedScene, position: Vector2) -> Node:
	var instance := scene.instance()
	instance.position = position
	get_tree().current_scene.add_child(instance)

	return instance
