class_name DamageEvent extends Event

var damage_amount: int
var damaged_card: Card
var damaging_card: Card

func _init(_damage_amount: int, _damaged_card: Card, _damaging_card: Card) -> void:
	damage_amount = _damage_amount
	damaged_card = _damaged_card
	damaging_card = _damaging_card

static func type():
	return "DamageEvent"
