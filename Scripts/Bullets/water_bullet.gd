class_name WaterBullet
extends Bullet

func damage() -> float:
	return StatManager.water_base_damage * StatManager.water_damage_mult
	
func infliction() -> String:
	return "bubble"
