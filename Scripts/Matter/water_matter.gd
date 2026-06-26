class_name Water_Matter
extends Matter

@export var Water_Bullet: PackedScene

func shoot() -> Bullet:
	return Water_Bullet.instantiate()
