extends HBoxContainer

onready var label = $Label

export var player_stats: Resource



func _ready() -> void:
	player_stats.connect("missiles_changed", self, "_on_PlayerStats_missiles_changed")
	player_stats.connect("missiles_unlocked", self, "_on_PlayerStats_missiles_unlocked")
	visible = false	


func _on_PlayerStats_missiles_changed(value: int) -> void:
	label.text = str(value)


func _on_PlayerStats_missiles_unlocked(value: bool) -> void:
	visible = value



