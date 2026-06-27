class_name WaterCard
extends Card

func _ready() -> void:
	id = 4
	times_applied = 0

# Card title
func get_title() -> String:
	return "Ride the Wave"
	
# Text describing the card
func get_description() -> String:
	return "Upgrades water's stats"
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	if times_applied == 0:
		return "Unlocks water dust, matter, and bullets. Also unlocks associated reactions"

	return "Bullet Damage Multiplier: " + str(get_amount(times_applied)) + " -> " + str(get_amount(times_applied + 1))

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	if amount == 1:
		return 1.0
	
	return pow(2, (amount - 1) / 2)
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	if times_applied == 1:
		StatManager.spawn_water = true
		return
	
	StatManager.water_damage_mult = get_amount(times_applied)
	
	if times_applied > 10:
		CardManager.remove_card(id)
