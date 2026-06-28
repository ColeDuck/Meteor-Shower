extends CanvasLayer

@export var Card: PackedScene
var paused: bool = false
var cards: Array[Card]
var total_cards

var player: Asteroid

func start() -> void:
	paused = true
	player = Asteroid.instance
	
	# Get the three cards
	cards = CardManager.get_three_cards()
	if cards.is_empty():
		end()
		return
		
	# Move them onto the screen
	for i in cards.size():
		var card: Card = cards.get(i)
		add_child(card)
		card.visible = true
		card.position = Vector2((300 * i) + 120, 150)
		card.display()
	
func end() -> void:
	# Empty card array
	for i in cards.size():
		var card: Card = cards.get(i)
		remove_child(card)
		card.visible = false
	player.end_level_up()
	
	cards.clear()
	paused = false
	
func me_clicked(id: int):
	for i in range(cards.size()):
		var card: Card = cards.get(i)
		if card.id == id:
			card.do_upgrade()
	end()
