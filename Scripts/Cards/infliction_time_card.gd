class_name InflictionTimeCard
extends Card

func _ready() -> void:
	id = 12
	times_applied = 0

# Card title
func get_title() -> String:
	return "Get It Off!"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades the length of status effects"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Min: %.2fs -> %.2fs\nMax: %.2fs -> %.2fs" % [\
	get_min(times_applied), get_min(times_applied + 1),\
	get_max(times_applied), get_max(times_applied + 1)]

# This is where the calculation or whatever is
func get_min(amount: int) -> int:
	
	if amount == 0:
		return 2
	if amount == 1:
		return 3
	if amount == 2:
		return 4
	if amount == 3:
		return 5
	return 0
	
func get_max(amount: int) -> int:
	if amount == 0:
		return 5
	if amount == 1:
		return 7
	if amount == 2:
		return 9
	if amount == 3:
		return 12
	return 0
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.min_infliction_time = get_min(times_applied)
	StatManager.max_infliction_time = get_min(times_applied)
	
	# On the number there time we will cull it
	if times_applied >= 3:
		CardManager.remove_card(id)
