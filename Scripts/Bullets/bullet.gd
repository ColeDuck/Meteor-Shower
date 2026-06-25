class_name Bullet
extends Area2D

var angle: float = 0 # Default
var speed: float = 0

func damage() -> float:
	return 0
	
func _physics_process(delta: float) -> void:
	position += speed * delta * Vector2(cos(rotation), sin(rotation))
	
