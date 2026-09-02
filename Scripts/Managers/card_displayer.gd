class_name CardDisplay
extends CanvasLayer

@export var Card: PackedScene
var paused: bool = false
var cards: Array[Card]
var total_cards

var player: Asteroid

func _ready() -> void:
	player = Asteroid.instance
	player.start_card.connect(start)

func start() -> void:
	GlobalVariables.game_paused = true
	
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
		card.callback = me_clicked
		card.position = Vector2((350 * i) + 435, 365)
		card.display()
	
func end() -> void:
	# Empty card array
	for i in cards.size():
		var card: Card = cards.get(i)
		remove_child(card)
		card.visible = false
	player.end_level_up()
	
	cards.clear()
	GlobalVariables.game_paused = false
	
func me_clicked(id: int):
	for i in range(cards.size()):
		var card: Card = cards.get(i)
		if card.id == id:
			card.do_upgrade()
	end()
