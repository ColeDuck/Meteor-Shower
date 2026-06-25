class_name Fire_Dust
extends Dust

var fire_matter = preload("res://Scenes/Matter/fire_matter.tscn")

func collect() -> Matter:
	return fire_matter.instantiate()
