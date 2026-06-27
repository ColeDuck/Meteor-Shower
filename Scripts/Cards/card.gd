class_name Card
extends Node2D

var times_applied: int = 0
@export var id: int

# Card title
func get_title() -> String:
	return ""
	
# Text describing the card
func get_description() -> String:
	return ""
	
# Bottom text showing what the upgrade actually does
func get_upgrade_text() -> String:
	return ""
	
# This is where the calculation or whatever is
func get_amount(amount: int) -> float:
	return 0.0
	
# Changes stats in StatManager (implicitly increases stats)
func do_upgrade() -> void:
	pass
