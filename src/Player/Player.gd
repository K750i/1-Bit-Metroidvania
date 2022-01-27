extends KinematicBody2D

const DustEffect: PackedScene = preload("res://src/Effects/DustEffect.tscn")
const JumpEffect: PackedScene = preload("res://src/Effects/JumpEffect.tscn")
const PlayerBullet: PackedScene = preload("res://src/Player/PlayerBullet.tscn")
const PlayerMissile: PackedScene = preload("res://src/Player/PlayerMissile.tscn")
const WallDustEffect: PackedScene = preload("res://src/Effects/WallDustEffect.tscn")

export var FRICTION := 0.25
export var GRAVITY := 600
export var SPEED := Vector2(100, 200)
export var BULLET_SPEED := 250
export var MISSILE_SPEED := 150
export var SLIDE_SPEED := 2000
export var player_stats: Resource
export var main_instances: Resource

onready var animation_player: AnimationPlayer = $SpriteAnimation
onready var blink_player: AnimationPlayer = $BlinkAnimation
onready var sprite: Sprite = $Sprite
onready var gun: Node2D = $Sprite/PlayerGun
onready var gun_muzzle: Position2D = $Sprite/PlayerGun/Muzzle
onready var camera_follow: RemoteTransform2D = $CameraFollow

enum { MOVE, WALL_SLIDE }

var state := MOVE
var motion := Vector2.ZERO
var coyote_jump_enabled := false
var jump_pressed := false	# to allow jump when player is slightly off the ground
var double_jump := true
var can_fire := true
var invincible := false setget set_invincible

# warning-ignore:unused_signal
signal hit_door(door)



func _ready() -> void:
	animation_player.playback_speed = 0.6
	# warning-ignore-all:return_value_discarded
	player_stats.connect("died", self, "_on_player_died")
	main_instances.Player = self
	camera_follow.remote_path = main_instances.WorldCamera.get_path()
	
	
func _exit_tree() -> void:
	main_instances.Player = null
	
	
func _on_Hurtbox_hit(damage) -> void:
	if not invincible:
		player_stats.health -= damage
		blink_player.play("blink")
	
	
func _on_player_died() -> void:
	queue_free()
	

func _on_PowerUpDetector_area_entered(area: Area2D) -> void:
	if area is PowerUp:
		area._pickup()
	
	
func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			var input_vector := get_input_vector()
			apply_horizontal_force(input_vector)
			apply_gravity(delta)
			jump(input_vector)
			play_animation({input_vector = input_vector})
			move(input_vector)
			
			wall_slide_check()
		WALL_SLIDE:
			var axis := get_wall_axis()
			wall_slide_drop_check(delta, axis)
			wall_slide_down_check(delta)
			wall_slide_jump_check(axis)
			play_animation({axis = axis})
			move(Vector2.ZERO)
					
	if Input.is_action_pressed("fire") and can_fire:
		fire_bullet()
		can_fire = false
		reset_fire_enabled(0.25)
	
	# using the same timer, which means after firing missile you can't
	# fire bullet too before that duration expires
	if Input.is_action_just_pressed("fire_missile") and can_fire:
		if player_stats.missiles > 0 and player_stats.missiles_unlocked:
			fire_missile()
			can_fire = false
			reset_fire_enabled(1.0)


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
			
			
	if Input.is_action_just_released("up") and motion.y < -80.0:
		motion.y = -80.0


func reset_coyote_time() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	coyote_jump_enabled = false


func reset_jump_time() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	jump_pressed = false


func move(input_vector: Vector2) -> void:
	var snap_vector := Vector2.DOWN * 10.0 if input_vector.y == 0 else Vector2.ZERO
	motion.y = move_and_slide_with_snap(motion, snap_vector, Vector2.UP, true, 4, PI/3).y
	

func play_animation(params: Dictionary) -> void:
	match state:
		MOVE:
			var facing := get_local_mouse_position().x
			# only update scale.x if facing isn't zero
			if facing:
				sprite.scale.x = sign(facing)
				
			if params.has('input_vector') and params['input_vector'].x != 0:
				if params['input_vector'].x * sprite.scale.x > 0:
					animation_player.play("run")
				else:
					animation_player.play_backwards("run")		
			else:
				animation_player.play("idle")
			
			# overrides run & idle if in the air
			if not is_on_floor():
				animation_player.play("jump")
		WALL_SLIDE:
			sprite.scale.x = params['axis']
			animation_player.play("wall_slide")
		

func create_dust_effect() -> void:
	Utils.instance_scene_on_main(DustEffect, global_position)


func fire_bullet() -> void:
	var bullet := Utils.instance_scene_on_main(PlayerBullet, gun_muzzle.global_position) as Node2D
	bullet.velocity = Vector2.RIGHT.rotated(gun.global_rotation) * BULLET_SPEED
	bullet.rotation = bullet.velocity.angle()


func fire_missile() -> void:
	var missile := Utils.instance_scene_on_main(PlayerMissile, gun_muzzle.global_position) as Node2D
	missile.velocity = Vector2.RIGHT.rotated(gun.global_rotation) * MISSILE_SPEED
	motion -= missile.velocity
	missile.rotation = missile.velocity.angle()
	player_stats.missiles -= 1
	

func reset_fire_enabled(duration: float) -> void:
	yield(get_tree().create_timer(duration), "timeout")
	can_fire = true


func set_invincible(value: bool) -> void:
	invincible = value


func wall_slide_check() -> void:
	if not is_on_floor() and is_on_wall() and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		state = WALL_SLIDE
		double_jump = true
		create_dust_effect()


func get_wall_axis() -> int:
	var is_right_wall := test_move(transform, Vector2.RIGHT)
	var is_left_wall := test_move(transform, Vector2.LEFT)
	return int(is_left_wall) - int(is_right_wall)


func wall_slide_jump_check(wall_axis: int) -> void:
	if Input.is_action_just_pressed("up"):
		motion.y = -SPEED.y * .5
		motion.x = wall_axis * SPEED.x * 5
		var pos_offset := Vector2(3, 0) if wall_axis > 0 else Vector2(-4, 0)
		var dust: Node = Utils.instance_scene_on_main(WallDustEffect, position + pos_offset)
		dust.scale.x = wall_axis
		state = MOVE


func wall_slide_drop_check(delta: float, axis: int) -> void:
	if Input.is_action_just_pressed("right"):
		motion.x = SPEED.x * delta
		motion.y = 0
		state = MOVE
			
	if Input.is_action_just_pressed("left"):
		motion.x = -SPEED.x * delta
		motion.y = 0
		state = MOVE
		
	if is_on_floor() or axis == 0:
		state = MOVE
	
	
func wall_slide_down_check(delta: float) -> void:
	var max_slide_speed := SLIDE_SPEED
	
	if Input.is_action_pressed("down"):
		max_slide_speed = SLIDE_SPEED * 3
		
	motion.y = max_slide_speed * delta
	motion.x = 0


func save() -> Dictionary:
	return {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"position_x": position.x,
		"position_y": position.y,
	}




