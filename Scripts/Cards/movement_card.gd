class_name MovementCard
extends Card

func _ready() -> void:
	id = 14
	times_applied = 0

# Card title
func get_title() -> String:
	return "Gotta Go Fast"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades your asteroid's movement capabilities"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Acceleration: %.2f -> %.2f\nMax speed: %.2f -> %.2f" % [\
	get_acc(times_applied), get_acc(times_applied + 1),\
	get_max(times_applied), get_max(times_applied + 1)]

# This is where the calculation or whatever is
func get_acc(amount: int) -> int:
	
	if amount == 0:
		return 40
	if amount == 1:
		return 60
	if amount == 2:
		return 80
	if amount == 3:
		return 90
	if amount == 4:
		return 100
	return 0
	
func get_max(amount: int) -> int:
	if amount == 0:
		return 80
	if amount == 1:
		return 100
	if amount == 2:
		return 120
	if amount == 3:
		return 130
	if amount == 4:
		return 150
	return 0
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.acceleration = get_acc(times_applied)
	StatManager.max_velocity = get_max(times_applied)
	
	# On the number there time we will cull it
	if times_applied >= 4:
		CardManager.remove_card(id)
