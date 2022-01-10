extends "res://src/Enemies/Enemy.gd"

enum Direction { LEFT = -1, RIGHT = 1 }

export(Direction) var walking_direction

onready var sprite: Sprite = $Sprite
onready var floorLeft: RayCast2D = $FloorLeft
onready var floorRight: RayCast2D = $FloorRight
onready var wallLeft: RayCast2D = $WallLeft
onready var wallRight: RayCast2D = $WallRight


func _ready() -> void:
	walking_direction = Direction.LEFT
	

func _physics_process(_delta: float) -> void:
	match walking_direction:
		Direction.LEFT:
			if not floorLeft.is_colliding() or wallLeft.is_colliding():
				walking_direction = Direction.RIGHT
		Direction.RIGHT:
			if not floorRight.is_colliding() or wallRight.is_colliding():
				walking_direction = Direction.LEFT
	
	motion.x = walking_direction * MAX_SPEED
	sprite.scale.x = sign(motion.x)
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 4, Vector2.UP, true, 4, deg2rad(46))


