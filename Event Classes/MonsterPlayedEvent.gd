class_name MonsterPlayedEvent extends Event

var card_played: Card

func _init(_card_played: Card) -> void:
	card_played = _card_played

static func type():
	return "MonsterPlayedEvent"
