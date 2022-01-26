extends Node

const SAVE_PATH := "user://save.dat"


func save_game() -> void:
	var file := File.new()
	file.open(SAVE_PATH, File.WRITE)
	var nodes := get_tree().get_nodes_in_group("persist")
	for node in nodes:
		var data: Dictionary = node.save()
		file.store_line(to_json(data))
	file.close()
	

func load_game() -> void:
	var file := File.new()
	if not file.file_exists(SAVE_PATH): return
	
	# release all persist nodes to re-create them from file
	var nodes := get_tree().get_nodes_in_group("persist")
	for node in nodes:
		node.queue_free()
		
	file.open(SAVE_PATH, File.READ)
	while not file.eof_reached():
		var line = parse_json(file.get_line())
		if line != null:
			# each persist node must save their own path (among other data)
			# in order to be reloaded at a later time
			var new_node = load(line["filename"]).instance()
			get_node(line["parent"]).add_child(new_node, true)
			new_node.position = Vector2(line["position_x"], line["position_y"])

			# dynamically set all other properties aside from the 4 above
			for property in line.keys():
				if (property == "filename" or
					property == "parent" or
					property == "position_x" or
					property == "position_y"): continue
				new_node.set(property, line[property])
	
	file.close()
	
	
	
