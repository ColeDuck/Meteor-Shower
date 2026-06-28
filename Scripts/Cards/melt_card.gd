class_name MeltCard
extends Card

func _ready() -> void:
	id = 8
	times_applied = 0

# Card title
func get_title() -> String:
	return "Is it getting hot in here?"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades the power of melt (burning + bubble or frostbite)"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Damage multiplier: %.2f -> %.2f" % [\
	get_amount(times_applied), get_amount(times_applied + 1)]

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	
	return pow(2.3, amount / 2.0)
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.vapemelt_damage_mult = get_amount(times_applied)
	
	if times_applied > 5:
		CardManager.remove_card(id)
