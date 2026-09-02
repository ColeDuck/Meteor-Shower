extends Node2D

@export var camera: Camera2D

func update_position() -> void:
	position = camera.get_screen_center_position() - (camera.get_viewport_rect().size / 10)
