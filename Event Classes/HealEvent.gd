class_name HealEvent extends Event

var heal_amount: int
var healed_card: Card
var healing_card: Card

func _init(_heal_amount: int, _healed_card: Card, _healing_card: Card) -> void:
	heal_amount = _heal_amount
	healed_card = _healed_card
	healing_card = _healing_card
	

static func type():
	return "HealEvent"
