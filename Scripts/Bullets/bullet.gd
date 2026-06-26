class_name Bullet
extends Area2D

var velocity: Vector2

var rotate_time: float = 0.25
var last_rotate: float = 0
var rotation_index: int = 0
var time_alive: float = 0


func damage() -> float:
	return 0
	
func destroy() -> void:
	pass

func infliction() -> String:
	return ""
	
func _physics_process(delta: float) -> void:
	position += velocity * delta
	
	last_rotate += delta
	if last_rotate > rotate_time:
		# Rotate 
		rotation_index = (rotation_index + 1) % 4
		rotation = rotation_index * (PI/4)
		last_rotate = 0
		
	time_alive += delta
	if time_alive > 7:
		queue_free()
		
