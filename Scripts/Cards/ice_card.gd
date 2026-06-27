class_name IceCard
extends Card

func _ready() -> void:
	id = 5
	times_applied = 0

# Card title
func get_title() -> String:
	return "Freezing Depths"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades ice's stats"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	if times_applied == 0:
		return "Unlocks ice dust, matter, and bullets. Also unlocks associated reactions"

	return "Damage Multiplier: " + str(get_amount(times_applied)) + " -> " + str(get_amount(times_applied + 1))

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	if amount == 1:
		return 1.0
	
	return pow(2, (amount - 1) / 2)
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	if times_applied == 1:
		StatManager.spawn_ice = true
		return
	
	StatManager.ice_damage_mult = get_amount(times_applied)
	
	if times_applied > 10:
		CardManager.remove_card(id)
