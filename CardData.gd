@tool
class_name CardData extends Resource

signal card_data_changed(card_data: CardData)

@export var health := 1:
	set(value):
		health = value
		card_data_changed.emit(self)
		
@export var attack := 1:
	set(value):
		attack = value
		card_data_changed.emit(self)	
		
@export var abilities: Array[Ability]

func print_card():
	for ability in abilities:
		print(str(ability))
		for condition in ability.conditions:
			print(str(condition))
