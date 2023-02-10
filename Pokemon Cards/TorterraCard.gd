extends Card

func connect_ability():
	EventManager.add_listener(HealEventArgs, activate_ability)

func disconnect_ability():
	EventManager.remove_listener(HealEventArgs, activate_ability)
	
func activate_ability(event_args: EventArgs):
	var heal_event_args = event_args as HealEventArgs
	if heal_event_args.healed_card != self:
		health += heal_event_args.heal_amount
	
