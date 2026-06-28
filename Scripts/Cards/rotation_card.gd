class_name RotationCard
extends Card

func _ready() -> void:
	id = 13
	times_applied = 0

# Card title
func get_title() -> String:
	return "Weeeee Spiiinnnn"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades the ability for your asteroid to rotate"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Acceleration: %.2f -> %.2f\nMax rotation: %.2f -> %.2f" % [\
	get_acc(times_applied), get_acc(times_applied + 1),\
	get_max(times_applied), get_max(times_applied + 1)]

# This is where the calculation or whatever is
func get_acc(amount: int) -> int:
	
	if amount == 0:
		return 5
	if amount == 1:
		return 5.5
	if amount == 2:
		return 6.5
	if amount == 3:
		return 8
	if amount == 4:
		return 10
	return 0
	
func get_max(amount: int) -> int:
	if amount == 0:
		return 2
	if amount == 1:
		return 5
	if amount == 2:
		return 10
	if amount == 3:
		return 20
	if amount == 4:
		return 40
	return 0
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.rotation_acceleration = get_acc(times_applied)
	StatManager.max_rotation = get_max(times_applied)
	
	# On the number there time we will cull it
	if times_applied >= 4:
		CardManager.remove_card(id)
