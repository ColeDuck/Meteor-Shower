class_name Bullet
extends Area2D

var velocity: Vector2

func damage() -> float:
	return 0
	
func _physics_process(delta: float) -> void:
	position += velocity * delta
	
