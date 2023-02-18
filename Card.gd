@tool
class_name Card extends Control

@onready var health_text = $Background/Health as Label
@onready var attack_text = $Background/Attack as Label

@export var card_data: CardData:
	set(value):
		card_data = value
		update_card_data(card_data)
		card_data.card_data_changed.connect(update_card_data)

@export var health: int:
	set(value):
		health = value
		if health <= 0:
			kill_card()
		
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
	if card_data == null:
		return
	
	state = CardState.Hand
	
	for ability in card_data.abilities:
		ability.card = self

func update_card_data(_card_data):
	health = _card_data.health
	attack = _card_data.attack

var state: CardState = CardState.None:
	set(value):
		print("Card state is " + str(CardState.Hand))
		for ability in card_data.abilities:
			ability.handle_listening(state, value)
			for condition in ability.conditions:
				condition.handle_listening(state, value)
		state = value

var is_attacking := false
var is_healing := false

enum CardState {
	None,
	Hand,
	Board
}

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_middle"):
		if state == CardState.Hand:
			state = CardState.Board
			switch_container("Board")
			EventManager.invoke_event(MonsterPlayedEvent.new(self))
		else:
			state = CardState.Hand
			switch_container("Hand")
			EventManager.invoke_event(MonsterReturnToHandEvent.new(self))
			
	if state == CardState.Board:
		if event.is_action_pressed("mouse_left") and !is_healing:
			is_attacking = true
		elif event.is_action_pressed("mouse_right") and !is_attacking:
			is_healing = true
		elif event.is_action_released("mouse_left") and !is_healing:
			var card = find_card_under_mouse()
			if card != null:
				damage_card(card)
			is_attacking = false
		elif event.is_action_released("mouse_right") and !is_attacking:
			var card = find_card_under_mouse()
			if card != null:
				heal_card(card)
			is_healing = false

func find_card_under_mouse() -> Card:
	var space = get_world_2d().direct_space_state
	var mouse_position = get_global_mouse_position()
	var query = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.position = mouse_position
	var collision = space.intersect_point(query, 1)
	if !collision.is_empty():
		var card = collision[0].collider.get_parent().get_parent() as Card
		if card.state != CardState.Board:
			return null
		elif card == self:
			return null
		else:
			return card
	else:
		return null
	
func switch_container(container_name: String):
	var container = get_tree().current_scene.find_child(container_name)
	reparent(container, false)

func damage_card(card: Card):
	card.health -= self.attack
	var damage_event = DamageEvent.new(self.attack, card, self)
	EventManager.invoke_event(damage_event)
	
func heal_card(card: Card):
	card.health += self.health
	var heal_event = HealEvent.new(self.health, card, self)
	EventManager.invoke_event(heal_event)

func kill_card():
	EventManager.invoke_event(MonsterDiedEvent.new(self))
	queue_free()
