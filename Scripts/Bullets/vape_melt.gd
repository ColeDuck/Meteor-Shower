class_name VapeMelt
extends Bullet

func _ready() -> void:
	time_to_live = 1.0
	velocity = Vector2(0,0)
	super()

func damage() -> float:
	return StatManager.vapemelt_base_damage * StatManager.vapemelt_damage_mult
