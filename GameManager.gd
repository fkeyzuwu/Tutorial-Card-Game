extends Node

var player: Player
var AI: AIPlayer

var game_state := GameState.Start

enum GameState {
	Start,
	PlayerTurn,
	AiTurn
}


func switch_game_state(_game_state: GameState):
	game_state = _game_state
	
	match game_state:
		GameState.PlayerTurn:
			#give player control to do shit
			pass
		GameState.AiTurn:
			#Let The AI Play
			pass
