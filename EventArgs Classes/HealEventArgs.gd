class_name HealEventArgs extends EventArgs

var heal_amount: int
var healed_card: Card
var healing_card: Card

static func type():
	return "HealEventArgs"
