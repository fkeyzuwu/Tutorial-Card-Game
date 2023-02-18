class_name HealEvent extends Event

var amount: int
var actioned_card: Card
var affected_card: Card

func _init(_heal_amount: int, _healed_card: Card, _healing_card: Card) -> void:
	amount = _heal_amount
	affected_card = _healed_card
	actioned_card = _healing_card
	

static func type():
	return "HealEvent"
