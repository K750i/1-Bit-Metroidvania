extends Camera2D

export var player_stats: Resource

var shake_amount := 0.0
onready var timer: Timer = $Timer


func _ready() -> void:
	player_stats.connect("add_screenshake", self, "_on_PlayerStats_add_screenshake")


func _on_PlayerStats_add_screenshake() -> void:
	shake_screen(0.5, 0.8)
	
	
func _on_Timer_timeout() -> void:
	shake_amount = 0.0
	
	
func _process(delta: float) -> void:
	if shake_amount:
		offset = Vector2(
			rand_range(-shake_amount, shake_amount),
			rand_range(-shake_amount, shake_amount)
			)
	
	
func shake_screen(duration: float, amount: float) -> void:
	shake_amount = amount
	timer.wait_time = duration
	timer.start()	
	


