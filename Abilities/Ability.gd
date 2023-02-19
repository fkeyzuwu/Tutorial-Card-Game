class_name Ability extends Resource

var card: Card
@export var target := Target.new()
@export var event_triggers: Array[GDScript] = []
@export var ability_type: AbilityType = AbilityType.IntFlat
@export var activation_type: ActivationType = ActivationType.Constant
@export var activation_states: Array[Card.CardState] = [Card.CardState.Board]
@export var conditions: Array[Condition] = []

enum ActivationType {
	Constant
}

enum AbilityType {
	IntFlat,
	IntEvent
}

func is_activatable() -> bool:
	if activation_states.has(card.state):
		for condition in conditions:
			if !condition.is_met:
				return false
				
		return true
	else:
		return false
	

func activate(event: Event): #override for each ability, super first
	pass

func set_target(event: Event): #later should set array of cards
	match target.target_type:
		Target.TargetType.Self:
			target.card = card
			return
		Target.TargetType.ActionCard:
			for property in event.get_property_list():
				if property.name == "actioned_card":
					target.card = event.actioned_card
					return
			print("couldnt find property of actioned_card")
		Target.TargetType.AffectedCard:
			for property in event.get_property_list():
				if property.name == "affected_card":
					target.card = event.affected_card
					return
			print("couldnt find property of affected_card")	
	
	print("couldn't find target")
	
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
