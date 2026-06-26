class_name Blob
extends Node2D

var max_time: float
var max_size: float
var change_per_second: Vector2

var offset: Vector2

var total_time: float = 0

var fuck_you: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fuck_you = get_node("../../Asteroid/MainCam")
	top_level
	scale = Vector2(0,0)
	change_per_second = Vector2(max_size, max_size) / (2 * max_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	position = fuck_you.get_screen_center_position() + offset
	# Calculate progress as a ratio between 0.0 and 1.0
	var t = clamp(total_time / max_time, 0.0, 1.0)

	if total_time > max_time:
		queue_free()

	# Remap t to a 0→1→0 arc using a smooth curve
	var meow = pow(sin(t * PI), 0.5)  # peaks at t=0.5, smooth on both ends

	scale = Vector2(meow, meow) * max_size
		
	total_time += delta
