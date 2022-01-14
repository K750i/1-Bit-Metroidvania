extends KinematicBody2D

const DustEffect: PackedScene = preload("res://src/Effects/DustEffect.tscn")
const JumpEffect: PackedScene = preload("res://src/Effects/JumpEffect.tscn")
const PlayerBullet: PackedScene = preload("res://src/Player/PlayerBullet.tscn")

export var FRICTION := 0.25
export var GRAVITY := 600
export var SPEED := Vector2(100, 200)
export var BULLET_SPEED := 250
export var player_stats: Resource

onready var animation_player: AnimationPlayer = $SpriteAnimation
onready var blink_player: AnimationPlayer = $BlinkAnimation
onready var sprite: Sprite = $Sprite
onready var gun: Node2D = $Sprite/PlayerGun
onready var gun_muzzle: Position2D = $Sprite/PlayerGun/Muzzle

var motion := Vector2.ZERO
var coyote_jump_enabled := false
var jump_pressed := false	# to allow jump when player is slightly off the ground
var double_jump := true
var can_fire := true
var invincible := false setget set_invincible


func _ready() -> void:
	animation_player.playback_speed = 0.6
	player_stats.connect("died", self, "_on_player_died")
	
	
func _on_Hurtbox_hit(damage) -> void:
	if not invincible:
		player_stats.health -= damage
		blink_player.play("blink")
	
	
func _on_player_died() -> void:
	queue_free()
	
	
func _physics_process(delta: float) -> void:
	var input_vector := get_input_vector()
	apply_horizontal_force(input_vector)
	apply_gravity(delta)
	jump(input_vector)
	play_animation(input_vector)
	move(input_vector)
			
			
	if Input.is_action_pressed("fire") and can_fire:
		fire_bullet()
		can_fire = false
		reset_fire_enabled()
		

func get_input_vector() -> Vector2:
	var out := Vector2.ZERO
	
	out.x = Input.get_action_strength("right") - Input.get_action_strength("left")

	if Input.is_action_just_pressed("up"):
		jump_pressed = true
		reset_jump_time()
		if coyote_jump_enabled:
			out.y = -Input.get_action_strength("up")
	else:
		out.y = 0.0
		
	if is_on_floor():
		coyote_jump_enabled = true
		double_jump = true
		if jump_pressed:
			out.y = -Input.get_action_strength("up")
			
	if not is_on_floor():
		reset_coyote_time()
		
	return out


func apply_horizontal_force(input_vector: Vector2) -> void:
	if input_vector.x != 0:
		motion.x = input_vector.x * SPEED.x
	else:
		motion.x = lerp(motion.x, 0, FRICTION)


func apply_gravity(delta: float) -> void:
	motion.y += GRAVITY * delta


func jump(input_vector: Vector2) -> void:
	if input_vector.y < 0.0:
		motion.y = input_vector.y * SPEED.y
		Utils.instance_scene_on_main(JumpEffect, position)

	if not is_on_floor() and not coyote_jump_enabled:
		if Input.is_action_just_pressed("up") and double_jump:
			motion.y = -SPEED.y * 0.75
			Utils.instance_scene_on_main(JumpEffect, position)
			double_jump = false
			print("jump")
			
	if Input.is_action_just_released("up") and motion.y < 0.0:
		motion.y = 0.0


func reset_coyote_time() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	coyote_jump_enabled = false


func reset_jump_time() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	jump_pressed = false


func move(input_vector: Vector2) -> void:
	var snap_vector := Vector2.DOWN * 10.0 if input_vector.y == 0 else Vector2.ZERO
	motion.y = move_and_slide_with_snap(motion, snap_vector, Vector2.UP, true, 4, PI/3).y
	

func play_animation(input_vector: Vector2) -> void:
	sprite.scale.x = sign(get_local_mouse_position().x)
	if input_vector.x != 0:
		if input_vector.x * sprite.scale.x > 0:
			animation_player.play("run")
		else:
			animation_player.play_backwards("run")		
	else:
		animation_player.play("idle")
	
	# overrides run & idle if in the air
	if not is_on_floor():
		animation_player.play("jump")
		

func create_dust_effect() -> void:
	Utils.instance_scene_on_main(DustEffect, global_position)


func fire_bullet() -> void:
	var bullet := Utils.instance_scene_on_main(PlayerBullet, gun_muzzle.global_position) as Node2D
	bullet.velocity = Vector2.RIGHT.rotated(gun.global_rotation) * BULLET_SPEED
	bullet.rotation = bullet.velocity.angle()


func reset_fire_enabled() -> void:
	yield(get_tree().create_timer(0.25), "timeout")
	can_fire = true


func set_invincible(value: bool) -> void:
	invincible = value







