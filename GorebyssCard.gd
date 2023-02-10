extends Card

func _ready() -> void:
	super()
	ability_state = CardState.Hand
	state = CardState.Hand

func connect_ability():
	EventManager.add_listener(HealEvent, activate_ability)

func disconnect_ability():
	EventManager.remove_listener(HealEvent, activate_ability)
	
func activate_ability(event: Event):
	attack += 3
