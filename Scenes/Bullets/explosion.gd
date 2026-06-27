class_name Explosion
extends Bullet

func _ready() -> void:
	time_to_live = 0.4
	velocity = Vector2(0,0)
	super()

func damage() -> float:
	return StatManager.explode_base_damage * StatManager.explode_damage_mult
