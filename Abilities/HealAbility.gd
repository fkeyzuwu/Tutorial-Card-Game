class_name HealAbility extends Ability

@export var amount: int

func activate(event: Event):
	if !is_activatable():
		return
	
	set_target(event)
	
	if ability_type == AbilityType.IntFlat:
		target.card.health += amount
	elif ability_type == AbilityType.IntEvent:
		target.card.health += event.amount
