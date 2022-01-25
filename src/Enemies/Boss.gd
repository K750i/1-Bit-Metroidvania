extends "res://src/Enemies/Enemy.gd"

export var main_instance: Resource

onready var right_wall_check: RayCast2D = $RightWallCheck
onready var left_wall_check: RayCast2D = $LeftWallCheck

const Bullet: PackedScene = preload("res://src/Enemies/EnemyBullet.tscn")
const ACCELERATION := 70

var player: KinematicBody2D

signal died



func _on_Timer_timeout() -> void:
	fire	()


func _ready() -> void:
	player = main_instance.Player
	

func _process(delta: float) -> void:
	chase_player(delta)


func _exit_tree() -> void:
	._exit_tree()
	emit_signal("died")
	

func chase_player(delta: float):
	if not is_instance_valid(player): return

	var direction_to_move: = sign(player.global_position.x - global_position.x)
	motion.x += ACCELERATION * direction_to_move * delta
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	global_position.x += motion.x * delta
	rotation_degrees = motion.x / MAX_SPEED * 10

	if ((left_wall_check.is_colliding() and motion.x < 0) or
		(right_wall_check.is_colliding() and motion.x > 0)):
		motion.x *= -0.5


func fire() -> void:
	var bullet = Utils.instance_scene_on_main(Bullet, global_position)
	var bullet_velocity := Vector2.DOWN * 50
	var random_angle: float = deg2rad(30)
	bullet_velocity = bullet_velocity.rotated(rand_range(-random_angle, random_angle))
	bullet.velocity = bullet_velocity



