extends Control

@onready var hand: HBoxContainer = %Hand

var deck_path := "res://DeckBuilder/Decks/deck.tres"
var card_path := "res://Pokemon Cards/"
@export var card_scene: PackedScene

func _ready() -> void:
	var deck = ResourceLoader.load(deck_path) as Deck
	var keys = deck.cards.keys()
	
	for i in range(0, keys.size()):
		var card_name = keys[i].to_lower() + ".tres"
		var card_amount = deck.cards[keys[i]]
		
		var card = card_scene.instantiate() as Card
		var card_data = ResourceLoader.load(card_path + card_name)
		card.card_data = card_data
		hand.add_child(card)
