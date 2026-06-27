class_name Shatter
extends Bullet

func _ready() -> void:
	time_to_live = 0.4
	velocity = Vector2(0,0)
	super()

func damage() -> float:
	return StatManager.shatter_base_damage * StatManager.shatter_damage_mult
