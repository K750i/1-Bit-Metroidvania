extends KinematicBody2D

export var ACCELERATION := 512
export var MAX_SPEED := 64
export var FRICTION := 0.25
export var GRAVITY := 200
export var JUMP_FORCE := 128
export var MAX_SLOPE_ANGLE := 46

var motion := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var input_vector := get_input_vector()
	apply_horizontal_force(input_vector, delta)
	apply_friction(input_vector)
	jump_check()
	apply_gravity(delta)
	move()


func get_input_vector() -> Vector2:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	return input_vector


func apply_horizontal_force(input_vector: Vector2, delta: float) -> void:
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)


func apply_friction(input_vector: Vector2) -> void:
	if input_vector.x == 0:
		motion.x = lerp(motion.x, 0, FRICTION)


func apply_gravity(delta: float) -> void:
	motion.y += GRAVITY * delta
	motion.y = min(motion.y, JUMP_FORCE)


func jump_check() -> void:
	if Input.is_action_just_pressed("up") and is_on_floor():
		motion.y = -JUMP_FORCE
	if Input.is_action_just_released("up") and motion.y < 0:
		motion.y = 0


func move() -> void:
	motion = move_and_slide(motion, Vector2.UP)
	






















