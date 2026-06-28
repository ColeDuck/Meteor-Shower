class_name BubbleCard
extends Card

func _ready() -> void:
	id = 9
	times_applied = 0

# Card title
func get_title() -> String:
	return "Under the Sea"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades the speed of bubbles :3 (from water bullets))"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Speed: %.2f -> %.2f" % [\
	get_amount(times_applied), get_amount(times_applied + 1)]

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	
	return amount * 5 + 10
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.bubble_speed = get_amount(times_applied)
	
	# On the number there time we will cull it
	if times_applied > 3:
		CardManager.remove_card(id)
