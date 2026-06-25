class_name Meteor_Dust
extends Dust

var meteor_matter = preload("res://Scenes/Matter/meteor_matter.tscn")

func collect() -> Matter:
	return meteor_matter.instantiate()
