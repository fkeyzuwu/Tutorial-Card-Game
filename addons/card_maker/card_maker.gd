@tool
class_name CardMaker extends PanelContainer

@onready var card_list: ItemList = $MarginContainer/HBoxContainer/CardResourcesList
@onready var card: Card = $MarginContainer/HBoxContainer/Card
@onready var card_data_editor: CardDataEditor = $MarginContainer/HBoxContainer/CardDataEditor

const card_resource_path := "res://Pokemon Cards/"
var card_names: PackedStringArray

func _ready() -> void:
	card_names = DirAccess.get_files_at(card_resource_path)
	card_list.clear()
	for card in card_names:
		card_list.add_item(prettify_card_name(card))
		
	card_data_editor.update_card_data_ui(card.card_data)

func _on_card_resources_list_item_selected(index: int) -> void:
	var card_resource = load(card_resource_path + card_names[index])
	card.card_data = card_resource
	card_data_editor.update_card_data_ui(card_resource)

func prettify_card_name(card_name: String) -> String:
	return card_name.trim_suffix(".tres").to_pascal_case()
