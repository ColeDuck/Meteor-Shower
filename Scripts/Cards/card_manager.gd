extends Node2D

@export var Card: PackedScene
var cards: Array[Card]

@export var aMatterStorageCard: PackedScene
@export var aDustCard: PackedScene
@export var aMeteorCard: PackedScene
@export var aFireCard: PackedScene
@export var aWaterCard: PackedScene
@export var aIceCard: PackedScene
@export var aBubbleCard: PackedScene
@export var aBurnCard: PackedScene
@export var aExplodeCard: PackedScene
@export var aFreezeCard: PackedScene
@export var aFrostbiteCard: PackedScene
@export var aInflictionTimeCard: PackedScene
@export var aMeltCard: PackedScene
@export var aMovementCard: PackedScene
@export var aRotationCard: PackedScene
@export var aShatterCard: PackedScene
@export var aXPCard: PackedScene


func _enter_tree() -> void:
	cards.append(aMatterStorageCard.instantiate())
	cards.append(aDustCard.instantiate())
	cards.append(aMeteorCard.instantiate())
	cards.append(aFireCard.instantiate())
	cards.append(aWaterCard.instantiate())
	cards.append(aIceCard.instantiate())
	cards.append(aInflictionTimeCard.instantiate())
	cards.append(aMovementCard.instantiate())
	cards.append(aRotationCard.instantiate())
	cards.append(aXPCard.instantiate())

func get_three_cards() -> Array[Card]:
	cards.shuffle()
	
	if cards.size() >= 3:
		return [cards.get(0), cards.get(1), cards.get(2)]
	elif cards.size() == 2:
		return [cards.get(0), cards.get(1)]
	elif cards.size() == 1:
		return [cards.get(0)]
	else:
		return []
	
func add_card(id: int):
	if id == 3:
		cards.append(aFireCard.instantiate())
	if id == 4:
		cards.append(aWaterCard.instantiate())
	if id == 5:
		cards.append(aIceCard.instantiate())
	if id == 6:
		cards.append(aShatterCard.instantiate())
	if id == 7:
		cards.append(aFreezeCard.instantiate())
	if id == 8:
		cards.append(aMeltCard.instantiate())
	if id == 9:
		cards.append(aBubbleCard.instantiate())
	if id == 10:
		cards.append(aBurnCard.instantiate())
	if id == 11:
		cards.append(aFrostbiteCard.instantiate())
	if id == 16:
		cards.append(aExplodeCard.instantiate())
	
func contains_card(id: int):
	for card in cards:
		if card.id == id:
			return true
	return false
	
	
func remove_card(id: int):
	for i in range(cards.size()):
		var card: Card = cards.get(i)
		if card.id == id:
			cards.remove_at(i)
			return
