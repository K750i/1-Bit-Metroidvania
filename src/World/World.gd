extends Node
class_name MainWorld

export var main_instances: Resource

var current_level: Node2D



func _ready() -> void:
	VisualServer.set_default_clear_color(Color.black)
	if SaveAndLoad.is_loading:
		SaveAndLoad.load_game()
		
	main_instances.Player.connect("hit_door", self, "_on_Player_hit_door")


func _on_Player_hit_door(door: Area2D) -> void:
	call_deferred("change_level", door)


func change_level(door: Area2D) -> void:
	var offset := current_level.position
	current_level.queue_free()
	
	var NewLevel: PackedScene = load(door.path)
	var new_level := NewLevel.instance()
	add_child(new_level)
	
	var new_door := get_door_with_connection(door, door.connection)
	var exit_pos := new_door.position - offset
	new_level.position = door.position - exit_pos


func get_door_with_connection(collided_door: Area2D, connection: Resource) -> Area2D:
	var doors := get_tree().get_nodes_in_group("Door")
	for door in doors:
		if door.connection == connection and door != collided_door:
			return door
	return null




