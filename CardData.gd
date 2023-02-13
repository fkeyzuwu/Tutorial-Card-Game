class_name CardData extends Resource

@export var health: int
@export var attack: int
@export var abilities: Array[Ability]

func print_card():
	for ability in abilities:
		print(str(ability))
		for condition in ability.conditions:
			print(str(condition))
