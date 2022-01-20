extends "res://src/Enemies/Enemy.gd"

export var ACCELERATION := 100
export var main_instances: Resource

onready var sprite = $Sprite



func _on_VisibilityNotifier2D_screen_entered() -> void:
	set_physics_process(true)


func _ready() -> void:
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	var player: KinematicBody2D = main_instances.Player
	if player != null:
		chase_player(delta, player)


func chase_player(delta: float, player: KinematicBody2D) -> void:
	var direction: Vector2 = position.direction_to(player.position)
	
	motion += direction * ACCELERATION * delta
	motion = motion.clamped(MAX_SPEED)
	motion = move_and_slide(motion)
	sprite.flip_h = position.x < player.position.x



