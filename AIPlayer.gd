class_name AIPlayer extends Node2D

var card_path := "res://Pokemon Cards/"
@export var card_scene: PackedScene

@onready var hand: HBoxContainer = %"AI Hand"
@onready var board: HBoxContainer = %"AI Board"

var is_my_turn := false:
	get:
		if GameManager.game_state == GameManager.GameState.AiTurn:
			return true
		else:
			return false

func _ready() -> void:
	randomize()
	var card_names = Array(DirAccess.get_files_at(card_path))
	
	for i in range(5):
		var card = card_scene.instantiate() as Card
		var card_resource = ResourceLoader.load(card_path + card_names.pick_random())
		card.card_data = card_resource
		card.card_owner = "AIPlayer"
		hand.add_child(card)

func play_turn():
	if hand.get_child_count() >= 0:
		var hand_card = hand.get_children().pick_random() as Card
		if hand_card != null:
			play_card(hand_card)
			await ai_pause(2.0)
	
	if board.get_child_count() >= 0:
		var board_card = board.get_children().pick_random() as Card
		var player_board = GameManager.player_board
		if player_board.get_child_count() >= 0:
			var player_card = GameManager.player_board.get_children().pick_random() as Card
			board_card.damage_card(player_card)
			print(board_card.card_data.name + " damaged " + player_card.card_data.name)
			await ai_pause(2.0)
			
	GameManager.switch_game_state(GameManager.GameState.PlayerTurn)

func play_card(card: Card):
	GameManager.play_card_at_location(card, board)

func ai_pause(time: float):
	await get_tree().create_timer(time).timeout
