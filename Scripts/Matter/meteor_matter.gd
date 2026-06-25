class_name Meteor_Matter
extends Matter

@export var Meteor_Bullet: PackedScene

func shoot() -> Bullet:
	return Meteor_Bullet.instantiate()
