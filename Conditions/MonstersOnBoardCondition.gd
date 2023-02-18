class_name MonstersOnBoardCondition extends Condition

@export var amount_needed: int

func start_listening():
	EventManager.add_listener(MonsterPlayedEvent, on_condition_event_triggered)
	EventManager.add_listener(MonsterReturnToHandEvent, on_condition_event_triggered)
	EventManager.add_listener(MonsterDiedEvent, on_condition_event_triggered)

func stop_listening():
	EventManager.remove_listener(MonsterPlayedEvent, on_condition_event_triggered)
	EventManager.remove_listener(MonsterReturnToHandEvent, on_condition_event_triggered)
	EventManager.remove_listener(MonsterDiedEvent, on_condition_event_triggered)

func on_condition_event_triggered(event: Event):
	if DataManager.board_cards.size() >= amount_needed:
		is_met = true
