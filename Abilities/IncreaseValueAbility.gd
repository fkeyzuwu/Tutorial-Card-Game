class_name IncreaseValueAbility extends Ability

#var card_properties = card.get_property_list().filter(func(num): typeof(num) == TYPE_INT)
@export_enum("attack", "health") var value_name: String
@export var amount: int

func activate(event: Event):
	if is_activatable:
		if ability_type == AbilityType.IntFlat:
			card.set(value_name, card.get(value_name) + amount)
		elif ability_type == AbilityType.IntEvent:
			card.set(value_name, card.get(value_name + event.amount))
