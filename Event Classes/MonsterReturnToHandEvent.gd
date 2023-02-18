class_name MonsterReturnToHandEvent extends Event

var card_returned: Card

func _init(_card_returned: Card) -> void:
	card_returned = _card_returned

static func type():
	return "MonsterReturnToHandEvent"
