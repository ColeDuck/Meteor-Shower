class_name Water_Dust
extends Dust

var water_matter = preload("res://Scenes/Matter/water_matter.tscn")

func collect() -> Matter:
	return water_matter.instantiate()
