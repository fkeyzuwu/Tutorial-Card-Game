extends Card

func connect_ability():
	EventManager.add_listener(HealEvent, activate_ability)

func disconnect_ability():
	EventManager.remove_listener(HealEvent, activate_ability)
	
func activate_ability(event: Event):
	var heal_event = event as HealEvent
	if heal_event.healed_card != self:
		health += heal_event.heal_amount
	
