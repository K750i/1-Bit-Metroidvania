extends KinematicBody2D

export var FRICTION := 0.25
export var GRAVITY := 800
export var SPEED := Vector2(100, 200)

onready var animation_player: AnimationPlayer = $SpriteAnimation
onready var sprite: Sprite = $Sprite

var motion := Vector2.ZERO
var coyote_jump_enabled := false
	

func _physics_process(delta: float) -> void:
	var input_vector := get_input_vector()
	apply_horizontal_force(input_vector)
	apply_gravity()
	jump(input_vector)
	play_animation(input_vector)
	move(input_vector)


func get_input_vector() -> Vector2:
	var out: Vector2
	
	out.x = Input.get_action_strength("right") - Input.get_action_strength("left")

	if is_on_floor():
		coyote_jump_enabled = true
		
	if Input.is_action_just_pressed("up") and coyote_jump_enabled:
		out.y = -Input.get_action_strength("up")
	else:
		out.y = 0.0
	
	if not is_on_floor():
		reset_coyote_time()
		
	return out


func apply_horizontal_force(input_vector: Vector2) -> void:
	if input_vector.x != 0:
		motion.x = input_vector.x * SPEED.x
	else:
		motion.x = lerp(motion.x, 0, FRICTION)


func apply_gravity() -> void:
	motion.y += GRAVITY * get_physics_process_delta_time()


func jump(input_vector: Vector2) -> void:
	if input_vector.y < 0.0:
		motion.y = input_vector.y * SPEED.y
	if Input.is_action_just_released("up") and motion.y < 0.0:
		motion.y = 0.0


func reset_coyote_time() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	coyote_jump_enabled = false


func move(input_vector: Vector2) -> void:
	var snap_vector := Vector2.DOWN * 10.0 if input_vector.y == 0 else Vector2.ZERO
	motion.y = move_and_slide_with_snap(motion, snap_vector, Vector2.UP, true, 4, PI/3).y
	

func play_animation(input_vector: Vector2) -> void:
	if input_vector.x != 0:
		sprite.scale.x = sign(input_vector.x)
		animation_player.play("run")
	else:
		animation_player.play("idle")
	
	# overrides run & idle if in the air
	if not is_on_floor():
		animation_player.play("jump")
		



















