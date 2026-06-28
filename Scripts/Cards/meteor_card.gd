class_name MeteorCard
extends Card

func _ready() -> void:
	id = 2
	times_applied = 0

# Card title
func get_title() -> String:
	return "Meteor Shower"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades the damage of the meteor bullets (the brown default ones)"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Damage Multiplier: %.2f -> %.2f" % [\
	get_amount(times_applied), get_amount(times_applied + 1)]

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	if amount == 0:
		return 1.0
	
	return pow(2, amount / 2.0)
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.meteor_damage_mult = get_amount(times_applied)
	
	if times_applied > 10:
		CardManager.remove_card(id)
