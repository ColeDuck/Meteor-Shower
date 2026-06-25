class_name Matter
extends Node2D

# Make z index editable
@export var Nugget: Sprite2D
@export var Outline: Sprite2D

# Called when the node enters the scene tree for the first time.
func shoot() -> Bullet:
	return Bullet.new()
