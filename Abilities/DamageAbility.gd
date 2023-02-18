class_name DamageAbility extends Ability

@export var amount: int

func activate(event: Event):
	set_target(event)
	
	if is_activatable:
		if ability_type == AbilityType.IntFlat:
			card.health -= amount
		elif ability_type == AbilityType.IntEvent:
			card.health -= event.amount