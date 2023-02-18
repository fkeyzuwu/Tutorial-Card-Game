class_name DamageEvent extends Event

var amount: int
var actioned_card: Card
var affected_card: Card

func _init(_damage_amount: int, _damaged_card: Card, _damaging_card: Card) -> void:
	amount = _damage_amount
	affected_card = _damaged_card
	actioned_card = _damaging_card

static func type():
	return "DamageEvent"
