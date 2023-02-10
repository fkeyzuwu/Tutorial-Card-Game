extends Card

func connect_ability():
	EventManager.add_listener(DamageEvent, activate_ability)

func disconnect_ability():
	EventManager.remove_listener(DamageEvent, activate_ability)
	
func activate_ability(event: Event):
	health += 1
