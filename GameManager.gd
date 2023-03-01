extends Node

var player: Player
var player_hand: HBoxContainer
var player_board: HBoxContainer

var AI: AIPlayer
var ai_hand: HBoxContainer
var ai_board: HBoxContainer

var game_state := GameState.Start

enum GameState {
	Start,
	PlayerTurn,
	AiTurn
}

func start_game():
	var scene = get_tree().current_scene
	
	player = scene.find_child("Player") as Player
	player_hand = scene.find_child("Player Hand")
	player_board = scene.find_child("Player Board")
	
	AI = scene.find_child("AI_Player") as AIPlayer
	ai_hand = scene.find_child("AI Hand")
	ai_board = scene.find_child("AI Board")
	
	switch_game_state(GameState.PlayerTurn)

func play_card_at_location(card: Card, location: Control):
	switch_card_container(card, location)
	card.state = Card.CardState.Board
	EventManager.invoke_event(MonsterPlayedEvent.new(card))

func switch_game_state(_game_state: GameState):
	game_state = _game_state
	
	match game_state:
		GameState.PlayerTurn:
			print("PLAYER TURN")
		GameState.AiTurn:
			AI.play_turn()
			print("AI TURN")

func switch_card_container(card: Card, container: Control):
	card.reparent(container, false)
	#also do here all the event calls and shit depending on the container
