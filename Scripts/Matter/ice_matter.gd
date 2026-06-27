class_name Ice_Matter
extends Matter

@export var Ice_Bullet: PackedScene

func _ready():
	health = StatManager.ice_bullet_per

func shoot() -> Bullet:
	return Ice_Bullet.instantiate()
