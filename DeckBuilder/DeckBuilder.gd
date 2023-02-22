extends Control

var card_resource_path := "res://Pokemon Cards/"
var card_collection_path = "res://DeckBuilder/card_collection.json"

var card_resources: Array[CardData] #for flipping pages nshit
@export var card_scene: PackedScene

var book_cards: Array[DeckBuildingCard]

@onready var card_book: GridContainer = %CardBook
@onready var deck: ItemList = %Deck
@onready var previous_page_button: Button = %PreviousPageButton
@onready var next_page_button: Button = %NextPageButton

var current_card_collection: Dictionary = {} #key is card_name, value is amount in collection
var current_book_cards: Dictionary = {} #key is card_name, value is card_obj
var current_deck: Dictionary = {} #key is card_name, value is amount in deck

const cards_at_a_time = 21 # 7*3 right now
var card_amount: int

var current_page = 0
var card_names: PackedStringArray

func _ready() -> void:
	book_cards.assign(card_book.get_children())
	card_names = DirAccess.get_files_at(card_resource_path)
	card_amount = card_names.size()
	
	for card_name in card_names:
		current_card_collection[card_name] = 2 #idk
	
	for i in range(cards_at_a_time):
		if card_amount == i:
			print("max cards")
			break 
		var card_resource = load(card_resource_path + card_names[i]) as CardData
		book_cards[i].card_data = card_resource
		book_cards[i].amount = current_card_collection[card_names[i]]
		book_cards[i].on_card_clicked.connect(_on_card_book_card_clicked)
		current_book_cards[card_names[i]] = book_cards[i]

func _on_card_book_card_clicked(card: DeckBuildingCard):
	if card.amount <= 0:
		print("not enough cards to add to deck")
		return
	
	var card_name = card.card_data.resource_path.get_file()
	if !current_deck.has(card_name):
		current_deck[card_name] = 0
	
	current_deck[card_name] += 1
	card.amount -= 1
	current_card_collection[card_name] -= 1
	
	refersh_deck_list_ui()
	
func _on_deck_card_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	print("deck card clicked")
	var card_name = get_card_name_from_deck_list(deck.get_item_text(index))
	if current_book_cards.has(card_name):
		var book_card = current_book_cards[card_name]
		book_card.amount += 1
	current_card_collection[card_name] += 1
	current_deck[card_name] -= 1
	
	if current_deck[card_name] == 0:
		current_deck.erase(card_name)
		
	refersh_deck_list_ui()

func refersh_deck_list_ui():
	deck.clear()
	var keys = current_deck.keys()
	for i in current_deck.size():
		var card_name = keys[i]
		var updated_card_name = get_deck_list_card_name(current_deck[card_name], card_name)
		deck.add_item(updated_card_name)


func _on_next_page_button_pressed() -> void:
	for card in book_cards:
		card.hide()
	
	current_book_cards.clear()
	
	for i in range(cards_at_a_time):
		var index = cards_at_a_time * (current_page + 1) + i
		
		if card_amount <= index:
			print("max cards")
			break
		
		var card_name = card_names[index]
		var card_resource = load(card_resource_path + card_name) as CardData
		book_cards[i].card_data = card_resource
		book_cards[i].amount = current_card_collection[card_names[index]]
		current_book_cards[card_name] = book_cards[i]
		book_cards[i].show()
			
	current_page += 1
	previous_page_button.disabled = false
	
	if card_amount <= cards_at_a_time * (current_page + 1):
		next_page_button.disabled = true
	
	
func _on_previous_page_button_pressed() -> void:
	current_book_cards.clear()
	
	for i in range(cards_at_a_time):
		var index = cards_at_a_time * (current_page - 1) + i
		var card_name = card_names[index]
		var card_resource = load(card_resource_path + card_name) as CardData
		book_cards[i].card_data = card_resource
		book_cards[i].amount = current_card_collection[card_names[index]]
		current_book_cards[card_name] = book_cards[i]
		book_cards[i].show()
		
	current_page -= 1
	if current_page == 0:
		previous_page_button.disabled = true
		
	next_page_button.disabled = false

func get_card_name_from_deck_list(text: String) -> String:
	return text.substr(3).to_lower() + ".tres"

func get_deck_list_card_name(amount: int, card_name: String) -> String:
	return str(amount) + "x " + card_name.trim_suffix(".tres").to_pascal_case()

func _on_tree_exiting() -> void:
	var deck_resource = Deck.new()
	deck_resource.cards = current_deck
	ResourceSaver.save(deck_resource, "res://DeckBuilder/Decks/deck.tres")
