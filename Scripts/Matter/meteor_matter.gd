class_name Meteor_Matter
extends Matter

@export var Meteor_Bullet: PackedScene

func _ready():
	health = StatManager.meteor_bullet_per

func shoot() -> Bullet:
	return Meteor_Bullet.instantiate()
