class_name FireBullet
extends Bullet

func damage() -> float:
	return StatManager.fire_base_damage * StatManager.fire_damage_mult
	
func infliction() -> String:
	return "burn"
