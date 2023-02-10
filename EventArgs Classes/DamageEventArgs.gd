class_name DamageEventArgs extends EventArgs

var damage_amount: int
var damaged_card: Card
var damaging_card: Card

static func type():
	return "DamageEventArgs"
