class_name DestroyAbility extends Ability

func activate(event: Event):
	if !is_activatable():
		return
	
	set_target(event)
	
	target.card.kill_card()
