extends "res://src/Levels/Level.gd"

const PLAYER_LAYER := 0b1

onready var boss: KinematicBody2D = $Boss
onready var block_door: TileMap = $BlockDoor
onready var trigger: Area2D = $Trigger


func _on_Trigger_area_triggered() -> void:
	set_block_door(true)


func _on_Boss_died() -> void:
	set_block_door(false)


func _ready() -> void:
	trigger.connect("area_triggered", self, "_on_Trigger_area_triggered")


func set_block_door(active: bool) -> void:
	block_door.visible = active
	block_door.collision_mask = PLAYER_LAYER if active else 0
	






