class_name BurnCard
extends Card

func _ready() -> void:
	id = 10
	times_applied = 0

# Card title
func get_title() -> String:
	return "This is Fine"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades the damage of burning (from fire bullets)"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Damage multiplier: %.2f -> %.2f" % [\
	get_amount(times_applied), get_amount(times_applied + 1)]

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	
	return pow(1.9, amount / 2.0)
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.burn_damage_mult = get_amount(times_applied)
	
	# On the number there time we will cull it
	if times_applied > 8:
		CardManager.remove_card(id)
