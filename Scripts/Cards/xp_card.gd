class_name XPCard
extends Card

func _ready() -> void:
	id = 15
	times_applied = 0

# Card title
func get_title() -> String:
	return "More Points ^,^"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades XP gained when killing an enemy"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "XP multiplier: %.2f -> %.2f" % [\
	get_amount(times_applied), get_amount(times_applied + 1)]

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	if amount == 0:
		return 1.0
	if amount == 1:
		return 1.5
	if amount == 2:
		return 2.0
	if amount == 3:
		return 3.0
	if amount == 4:
		return 5.0
	if amount == 5:
		return 10.0
	if amount == 6:
		return 20.0
	return 1
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.xp_mult = get_amount(times_applied)
	
	# On the number there time we will cull it
	if times_applied >= 6:
		CardManager.remove_card(id)
