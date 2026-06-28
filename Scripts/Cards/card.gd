class_name Card
extends Button

var Title: Label
var Desc: Label
var Upgrade: Label

var times_applied: int = 0
@export var id: int
	
func display() -> void:
	%Title.text = get_title()
	%Desc.text = get_description()
	%Upgrade.text = get_upgrade_text()

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

func _input(event):
	if event is InputEventMouseButton:
		print("global click at ", event.position)

func _on_button_up() -> void:
	CardDisplayer.me_clicked(id)
