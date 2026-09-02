extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DustSpawner.location = self
	DustSpawner.opening_dust()
