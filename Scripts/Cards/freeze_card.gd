class_name FreezeCard
extends Card

func _ready() -> void:
	id = 7
	times_applied = 0

# Card title
func get_title() -> String:
	return "Berdly Simulator"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades the length of freeze (bubble + frostbite)"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Time: %.2fs -> %.2fs" % [\
	get_amount(times_applied), get_amount(times_applied + 1)]

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	
	return 2 * amount + 2
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.frozen_infliction_time = get_amount(times_applied)
	
	if times_applied > 5:
		CardManager.remove_card(id)
