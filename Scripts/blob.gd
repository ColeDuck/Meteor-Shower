class_name Blob
extends Node2D

var max_time: float
var max_size: float
var change_per_second: Vector2

var total_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_level
	scale = Vector2(0,0)
	change_per_second = Vector2(max_size, max_size) / (2 * max_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if total_time > max_time:
		queue_free()
	
	if total_time < max_time / 2:
		# Grow
		scale += change_per_second * delta
	else:
		scale -= change_per_second * delta
		
	total_time += delta
