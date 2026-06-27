class_name MatterStorageCard
extends Card

func _ready() -> void:
	id = 1
	times_applied = 0

# Card title
func get_title() -> String:
	return "Stronger Gravitational Pull"
	
# Text describing the card
func get_description() -> String:
	return "Increases maximum matter you can store"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return "Storage: " + str(get_amount(times_applied)) + " -> " + str(get_amount(times_applied + 1))
	
# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	if amount == 0:
		return 20
	if amount == 1:
		return 40
	if amount == 2:
		return 60
	if amount == 3:
		return 100
	if amount == 4:
		return 150
	if amount == 5:
		return 200
	
	return 0
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	StatManager.max_matter_storage = get_amount(times_applied)
	if times_applied == 5:
		CardManager.remove_card(id)
