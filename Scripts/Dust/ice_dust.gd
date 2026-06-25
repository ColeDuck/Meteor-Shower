class_name Ice_Dust
extends Dust

var ice_matter = preload("res://Scenes/Matter/ice_matter.tscn")

func collect() -> Matter:
	return ice_matter.instantiate()
