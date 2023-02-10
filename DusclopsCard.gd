extends Card

func connect_ability():
	EventManager.add_listener(DamageEvent, activate_ability)

func disconnect_ability():
	EventManager.remove_listener(DamageEvent, activate_ability)
	
func activate_ability(event: Event):
	var damage_event = event as DamageEvent
	if damage_event.damaged_card == self:
		if damage_event.damage_amount >= 5:
			damage_event.damaging_card.queue_free()
