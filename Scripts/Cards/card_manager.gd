extends Node2D

var cards: Array[Card]

func _ready() -> void:
	cards.append(MatterStorageCard.new())

func get_three_cards() -> Array[Card]:
	cards.shuffle()
	
	if cards.size() >= 3:
		return [cards.get(0), cards.get(1), cards.get(2)]
	elif cards.size() == 2:
		return [cards.get(0), cards.get(1), null]
	elif cards.size() == 1:
		return [cards.get(0), null, null]
	else:
		return [null, null, null]
	
func add_card(new_card: Card):
	cards.append(new_card)
	
func remove_card(id: int):
	for i in range(cards.size()):
		var card: Card = cards.get(i)
		if card.id == id:
			cards.remove_at(i)
			return
