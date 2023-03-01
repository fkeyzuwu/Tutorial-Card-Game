@tool
class_name CardData extends Resource

signal card_data_changed(card_data: CardData)
	
@export var name := "Default":
	set(value):
		name = value
		resource_name = name
		card_data_changed.emit(self)
		
@export_multiline var description := "Card does something very cool!":
	set(value):
		description = value
		card_data_changed.emit(self)

@export var health := 1:
	set(value):
		health = value
		card_data_changed.emit(self)
		
@export var attack := 1:
	set(value):
		attack = value
		card_data_changed.emit(self)	
			
@export var texture := load("res://sprites/pokemon/main-sprites/diamond-pearl/374.png") as Texture2D:
	set(value):
		texture = value
		card_data_changed.emit(self)

@export var background_color := Color.DARK_GRAY:
	set(value):
		background_color = value
		card_data_changed.emit(self)
		
@export var abilities: Array[Ability] = []

func print_card():
	for ability in abilities:
		print(str(ability))
		for condition in ability.conditions:
			print(str(condition))
