extends Control

@onready var player_hand: HBoxContainer = %"Player Hand"
@onready var ai_hand: HBoxContainer = %"AI Hand"

var deck_path := "res://DeckBuilder/Decks/deck.tres"
var card_path := "res://Pokemon Cards/"
@export var card_scene: PackedScene

func _ready() -> void:
	var deck = ResourceLoader.load(deck_path) as Deck
	var keys = deck.cards.keys()
	
	for i in range(keys.size()):
		var card_name = keys[i]
		var card_amount = deck.cards[card_name]
		for j in range(card_amount):
			var card = card_scene.instantiate() as Card
			card.card_data = ResourceLoader.load(card_path + card_name)
			card.card_owner = "Player"
			player_hand.add_child(card)
			
	GameManager.start_game()
