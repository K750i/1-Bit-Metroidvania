extends "res://src/Enemies/Enemy.gd"

const EnemyBullet: PackedScene = preload("res://src/Enemies/EnemyBullet.tscn")

onready var bullet_spawn_point = $BulletSpawnPoint
onready var fire_direction = $FireDirection

export var BULLET_SPEED := 30
export var spread := 15.0



func fire_bullet() -> void:
	var bullet: Node = Utils.instance_scene_on_main(EnemyBullet, bullet_spawn_point.global_position)
	var velocity: Vector2 = bullet_spawn_point.global_position.direction_to(fire_direction.global_position) * BULLET_SPEED
	velocity = velocity.rotated(deg2rad(rand_range(-spread, spread)))
	bullet.velocity = velocity
	


