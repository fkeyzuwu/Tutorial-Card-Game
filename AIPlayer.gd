class_name AIPlayer extends Node

@onready var hand: HBoxContainer = %Hand
@export var card_scene: PackedScene
@onready var board: HBoxContainer = %Board
var card_path := "res://Pokemon Cards/"

var is_my_turn := false:
	get:
		if GameManager.game_state == GameManager.GameState.AiTurn:
			return true
		else:
			return false

func _ready() -> void:
	randomize()
	var card_names = Array(DirAccess.get_files_at(card_path))
	for card in card_names:
		print(card)
	var card_amount = card_names.size()
	
	for i in range(5):
		var card = card_scene.instantiate() as Card
		var card_resource = ResourceLoader.load(card_path + card_names.pick_random())
		card.card_data = card_resource
		card.card_owner = "AIPlayer"
		hand.add_child(card)

func play_turn():
	var random_card = hand.pick_random()
	play_card(random_card)
	hand.erase(random_card)

func play_card(card: Card):
	board.reparent(card, false)
	card.show()
