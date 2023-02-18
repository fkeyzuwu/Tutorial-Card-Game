class_name Ability extends Resource

var card: Card
@export var target := Target.new()
@export var event_triggers: Array[GDScript]
@export var ability_type: AbilityType = AbilityType.IntFlat
@export var activation_type: ActivationType = ActivationType.Constant
@export var activation_states: Array[Card.CardState] = [Card.CardState.Board]
@export var conditions: Array[Condition]

enum ActivationType {
	Constant
}

enum AbilityType {
	IntFlat,
	IntEvent
}

func is_activatable() -> bool:
	if activation_states.has(card.state):
		return true
	else:
		return false
	

func activate(event: Event): #override for each ability, pass in args?
	pass

func set_target(event: Event) -> Card: #later should return array of cards for aoe
	match target.target_type:
		Target.TargetType.Self:
			return card
		Target.TargetType.ActionCard:
			if event.get_property_list().has("actioned_card"):
				return event.actioned_card
		Target.TargetType.AffectedCard:
			if event.get_property_list().has("affected_card"):
				return event.affected_card
				
	print("couldn't get a target")
	return null	
	
	
func handle_listening(current_state: Card.CardState, next_state: Card.CardState):
	if activation_states.has(next_state):
		if activation_states.has(current_state):
			return #already listening
		else:
			start_listening()
	elif activation_states.has(current_state):
		stop_listening()

func start_listening():
	for trigger in event_triggers:
		EventManager.add_listener(trigger, activate)

func stop_listening():
	for trigger in event_triggers:
		EventManager.remove_listener(trigger, activate)
