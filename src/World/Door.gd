extends Area2D

export var connection: Resource
export(String, FILE, "*.tscn") var path



func _on_body_entered(Player: Node) -> void:
	Player.emit_signal("hit_door", self)
