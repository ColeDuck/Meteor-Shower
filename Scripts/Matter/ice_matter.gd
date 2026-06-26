class_name Ice_Matter
extends Matter

@export var Ice_Bullet: PackedScene

func shoot() -> Bullet:
	return Ice_Bullet.instantiate()
