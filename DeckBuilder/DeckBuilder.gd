extends Control

var card_resource_path := "res://Pokemon Cards/"

var card_resources: Array[CardData] #for flipping pages nshit
@export var card_scene: PackedScene

@onready var card_book: GridContainer = %CardBook
@onready var deck: ItemList = %Deck

# using this because i need index for items list 
# +key value pair for card name + amount

var current_book_cards: Dictionary
var current_deck: Dictionary = {}

func _ready() -> void:
	var card_names = DirAccess.get_files_at(card_resource_path)
	for card_name in card_names:
		var card_resource = load(card_resource_path + card_name) as CardData
		var card = card_scene.instantiate() as DeckBuildingCard
		card.card_data = card_resource
		card_book.add_child(card)
		card.on_card_clicked.connect(_on_card_book_card_clicked)
		var real_card_name = card.card_data.name
		current_book_cards[real_card_name] = card

func _on_card_book_card_clicked(card: DeckBuildingCard):
	if card.amount <= 0:
		print("not enough cards to add to deck")
		return
	
	var card_name = card.card_data.name
	if !current_deck.has(card_name):
		current_deck[card_name] = 0
	
	current_deck[card_name] += 1
	card.amount -= 1
	
	refersh_deck_list_ui()
	
func _on_deck_card_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	print("deck card clicked")
	var card_name = deck.get_item_text(index).substr(3)
	var book_card = current_book_cards[card_name]
	book_card.amount += 1
	current_deck[card_name] -= 1
	
	if current_deck[card_name] == 0:
		current_deck.erase(card_name)
		
	refersh_deck_list_ui()
	#move card back to card list

func refersh_deck_list_ui():
	deck.clear()
	var keys = current_deck.keys()
	for i in current_deck.size():
		var card_name = keys[i]
		var card_amount = str(current_deck[card_name])
		deck.add_item(card_amount + "x " + card_name)
