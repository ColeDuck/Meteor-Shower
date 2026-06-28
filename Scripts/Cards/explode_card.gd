class_name ExplodeCard
extends Card

func _ready() -> void:
	id = 16
	times_applied = 0

# Card title
func get_title() -> String:
	return "Kablooey"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades the power of explosions (burning + meteor)"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Damage multiplier: %.2f -> %.2f" % [\
	get_amount(times_applied), get_amount(times_applied + 1)]

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	
	return pow(3.0, amount / 2.0)
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.explode_damage_mult = get_amount(times_applied)
	
	if times_applied > 4:
		CardManager.remove_card(id)
