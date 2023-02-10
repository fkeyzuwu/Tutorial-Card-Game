extends Card

func connect_ability():
	EventManager.add_listener(DamageEventArgs, activate_ability)

func disconnect_ability():
	EventManager.remove_listener(DamageEventArgs, activate_ability)
	
func activate_ability(event_args: EventArgs):
	health += 1
