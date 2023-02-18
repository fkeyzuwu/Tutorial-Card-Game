class_name Condition extends Resource

var ability: Ability
var is_met: bool = false
@export var listen_states: Array[Card.CardState] = [Card.CardState.Board]

func handle_listening(current_state: Card.CardState, next_state: Card.CardState):
	if listen_states.has(next_state):
		if listen_states.has(current_state):
			return #already listening
		else:
			start_listening()
	elif listen_states.has(current_state):
		stop_listening()

func on_condition_event_triggered(event: Event):
	pass

func start_listening(): #override for each condition
	pass
	
func stop_listening(): #override for each condition
	pass
