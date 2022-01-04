extends KinematicBody2D

export var FRICTION := 0.25
export var GRAVITY := 800
export var SPEED := Vector2(100, 200)

var motion := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var input_vector := get_input_vector()
	apply_horizontal_force(input_vector)
	apply_gravity()
	jump(input_vector)
	move()


func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-Input.get_action_strength("up") if Input.is_action_just_pressed("up") and is_on_floor() else 0.0
	)


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

func move() -> void:
	motion = move_and_slide(motion, Vector2.UP)
	






















