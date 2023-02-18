class_name SpecificCardCondition extends Condition

@export var card_inclusion := CardInclusion.Any

enum CardInclusion {
	Self,
	Other,
	Any,
}

func start_listening():
	for trigger in ability.event_triggers:
		EventManager.add_listener(trigger, on_condition_event_triggered)
		
func stop_listening():
	for trigger in ability.event_triggers:
		EventManager.remove_listener(trigger, on_condition_event_triggered)

func on_condition_event_triggered(event: Event):
	match card_inclusion:
		CardInclusion.Any: #why does this exist lol
			is_met = true
		CardInclusion.Other:
			for property in event.get_property_list():
				if property.name == "affected_card":
					if ability.card != event.affected_card:
						is_met = true
					else:
						is_met = false
		CardInclusion.Self:
			for property in event.get_property_list():
				if property.name == "affected_card":
					if ability.card == event.affected_card:
						is_met = true
					else:
						is_met = false
