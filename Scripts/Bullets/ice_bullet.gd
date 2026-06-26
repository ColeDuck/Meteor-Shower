class_name IceBullet
extends Bullet

func damage() -> float:
	return StatManager.ice_damage_mult * StatManager.ice_base_damage
	
func infliction() -> String:
	return "frostbite"
