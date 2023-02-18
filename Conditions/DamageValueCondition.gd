class_name DamageValueCondition extends Condition

@export var value = 1
@export var operator := Operator.MoreThanOrEqual

enum Operator {
	LessThan,
	LessThanOrEqual,
	MoreThan,
	MoreThanOrEqual,
	Equal
}

func start_listening():
	EventManager.add_listener(DamageEvent, on_condition_event_triggered)

func stop_listening():
	EventManager.remove_listener(DamageEvent, on_condition_event_triggered)

func on_condition_event_triggered(event: Event):
	var damage_event = event as DamageEvent
	
	match operator:
		Operator.LessThan:
			is_met = value > damage_event.amount
		Operator.LessThanOrEqual:
			is_met = value >= damage_event.amount
		Operator.MoreThan:
			is_met = value < damage_event.amount
		Operator.MoreThanOrEqual:
			is_met = value <= damage_event.amount
		Operator.Equal:
			is_met = value == damage_event.amount
