@tool
class_name CardDataEditor extends VBoxContainer

@onready var card: Card = $"../Card"
var current_card_data: CardData

@onready var name_text: LineEdit = $Name/MarginContainer/VBoxContainer/TextInput
@onready var description_text: TextEdit = $Description/MarginContainer/VBoxContainer/TextInput
@onready var health_text: SpinBox = $Health/MarginContainer/VBoxContainer/NumberInput
@onready var attack_text: SpinBox = $Attack/MarginContainer/VBoxContainer/NumberInput

func update_card_data_ui(card_data: CardData) -> void:
	current_card_data = card_data
	name_text.text = card_data.name
	description_text.text = card_data.description
	health_text.value = card_data.health
	attack_text.value = card_data.attack

func _on_name_text_changed(new_text: String) -> void:
	current_card_data.name = new_text
	card.card_data = current_card_data

func _on_description_text_changed() -> void:
	current_card_data.description = description_text.text
	card.card_data = current_card_data

func _on_health_value_changed(value: float) -> void:
	current_card_data.health = int(value)
	card.card_data = current_card_data

func _on_attack_value_changed(value: float) -> void:
	current_card_data.attack = int(value)
	card.card_data = current_card_data

