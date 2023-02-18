class_name HealAbility extends Ability

@export var amount: int

func activate(event: Event):
	if is_activatable:
		if ability_type == AbilityType.IntFlat:
			card.health += amount
		elif ability_type == AbilityType.IntEvent:
			card.health += event.amount
