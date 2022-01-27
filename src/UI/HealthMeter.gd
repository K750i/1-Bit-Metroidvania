extends Control

export var player_stats: Resource

onready var healthbar_empty: TextureRect = $Empty
onready var healthbar_full: TextureRect = $Full

const BAR_SIZE := 5

func _ready() -> void:
	# warning-ignore:return_value_discarded
	player_stats.connect("health_changed", self, "_on_player_health_changed")
	healthbar_empty.rect_size.x = player_stats.max_health * BAR_SIZE + 1
	healthbar_full.rect_size.x = player_stats.health * BAR_SIZE + 1


func _on_player_health_changed(value: int) -> void:
	healthbar_full.rect_size.x = value * BAR_SIZE + 1




