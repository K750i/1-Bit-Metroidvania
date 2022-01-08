extends Node2D

var pivot: Position2D

func _ready() -> void:
	pivot = owner.get_node("GunPivot")
	
	
func _process(_delta: float) -> void:
	rotation = pivot.get_local_mouse_position().angle()
