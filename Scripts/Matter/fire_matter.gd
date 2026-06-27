class_name Fire_Matter
extends Matter

@export var Fire_Bullet: PackedScene

func _ready():
	health = StatManager.fire_bullet_per

func shoot() -> Bullet:
	return Fire_Bullet.instantiate()
