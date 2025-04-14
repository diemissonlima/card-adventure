extends HBoxContainer
class_name PlayerHand

@export var hand_size: int

var player_deck: Array = []
var aux_deck: Array = []


func get_player_deck(deck: Array) -> void:
	player_deck = deck.duplicate()
	aux_deck = player_deck.duplicate()
	
	for j in range(hand_size):
		var index: int = randi() % player_deck.size()
		var card = player_deck[index]
		add_card_to_hand(card)
		player_deck.remove_at(index)


func add_card_to_hand(card: PackedScene) -> void:
	var card_scene = card.instantiate()
	add_child(card_scene)


func draw_card(quantity: int) -> void:
	for j in range(quantity):
		var card = player_deck[0]
		add_card_to_hand(card)
		player_deck.pop_front()
		
	if player_deck.is_empty():
		player_deck = aux_deck.duplicate()
		player_deck.shuffle()
