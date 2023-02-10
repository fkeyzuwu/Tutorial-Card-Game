class_name DamageEvent extends Event

var damage_amount: int
var damaged_card: Card
var damaging_card: Card

static func type():
	return "DamageEvent"
