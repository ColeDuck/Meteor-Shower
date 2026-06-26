class_name Fire_Matter
extends Matter

@export var Fire_Bullet: PackedScene

func shoot() -> Bullet:
	return Fire_Bullet.instantiate()
