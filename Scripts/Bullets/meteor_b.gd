class_name MeteorBullet
extends Bullet

func infliction() -> String:
	return "meteor"

func damage() -> float:
	return StatManager.meteor_base_damage * StatManager.meteor_damage_mult
