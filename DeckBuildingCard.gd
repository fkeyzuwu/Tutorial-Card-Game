@tool
class_name DeckBuildingCard extends Control

signal on_card_clicked(card: DeckBuildingCard)

#the amount of cards avaialbale
@export var amount := 2:
	set(value):
		amount = value
		print("card amount updated")
		
		if not is_inside_tree():
			await ready
		amount_text.text = str(amount) + "x"

@onready var amount_text: Label = %Amount

@onready var health_text: Label = %Health
@onready var attack_text: Label = %Attack
@onready var picture: TextureRect = %Picture
@onready var background_color: ColorRect = %Background
@onready var description: Label = %Description

@export var card_data: CardData:
	set(value):
		card_data = value
		if not is_inside_tree():
			await ready
		update_card_data(card_data)
		if !card_data.card_data_changed.is_connected(update_card_data):
			card_data.card_data_changed.connect(update_card_data)

@export_category("Current Stats")
@export var health: int:
	set(value):
		health = value
		
		if not is_inside_tree():
			await ready
		health_text.text = str(health)
		
@export var attack: int:
	set(value):
		attack = value
		if not is_inside_tree():
			await ready
		attack_text.text = str(attack)
		
func _ready() -> void:
	amount = amount #idk why i have to do this shit

func update_card_data(_card_data: CardData):
	health = _card_data.health
	attack = _card_data.attack
	picture.texture = _card_data.texture
	background_color.color = _card_data.background_color
	description.text = _card_data.description

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		on_card_clicked.emit(self)
