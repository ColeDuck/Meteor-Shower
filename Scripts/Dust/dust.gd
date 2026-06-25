class_name Dust
extends Area2D

func collect() -> Matter:
	return null
	
func remove():
	queue_free()
