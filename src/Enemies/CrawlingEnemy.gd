extends "res://src/Enemies/Enemy.gd"

onready var floor_cast: RayCast2D = $FloorCast
onready var wall_cast: RayCast2D = $WallCast

enum DIRECTION { LEFT = -1, RIGHT = 1 }

export(DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT



func _ready() -> void:
	wall_cast.cast_to.x *= WALKING_DIRECTION
	

func _physics_process(delta: float) -> void:
	if wall_cast.is_colliding():
		global_position = wall_cast.get_collision_point()
		
		var normal = wall_cast.get_collision_normal()
		global_rotation = normal.rotated(PI * 0.5).angle()
	else:
		# rotate the ray forward
		floor_cast.rotation_degrees = -MAX_SPEED * 10 * WALKING_DIRECTION * delta
		if floor_cast.is_colliding():
			global_position = floor_cast.get_collision_point()
			var normal = floor_cast.get_collision_normal()
			global_rotation = normal.rotated(PI * 0.5).angle()
		else:	# reached an edge
			rotation_degrees += 2 * WALKING_DIRECTION
			

	




