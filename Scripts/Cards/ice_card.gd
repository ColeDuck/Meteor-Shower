class_name IceCard
extends Card

@export var Ice: PackedScene

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

	return "Damage Multiplier: %.2f -> %.2f" %[\
	get_amount(times_applied), get_amount(times_applied + 1)]

# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	if amount == 1:
		return 1.0
	
	return pow(2, (amount / 2.0))
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	times_applied += 1
	
	if times_applied == 1:
		StatManager.spawn_ice = true
		DustSpawner.replace_dust(Ice)
		CardManager.add_card(11) # Frostbite
		if CardManager.contains_card(4) and !CardManager.contains_card(6):
			CardManager.add_card(6) # Shatter if water
		
		if CardManager.contains_card(3) and !CardManager.contains_card(8):
			CardManager.add_card(8) # Melt if fire
		if CardManager.contains_card(4) and !CardManager.contains_card(7):
			CardManager.add_card(7) # Freeze if water
		
		
		
		return
	
	StatManager.ice_damage_mult = get_amount(times_applied)
	
	if times_applied > 10:
		CardManager.remove_card(id)
