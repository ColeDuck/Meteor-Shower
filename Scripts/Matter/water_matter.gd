class_name Water_Matter
extends Matter

@export var Water_Bullet: PackedScene

func _ready():
	health = StatManager.water_bullet_per

func shoot() -> Bullet:
	return Water_Bullet.instantiate()
