class_name MonsterDiedEvent extends Event

var card_died: Card

func _init(_card_died: Card) -> void:
	card_died = _card_died

static func type():
	return "MonsterDiedEvent"
