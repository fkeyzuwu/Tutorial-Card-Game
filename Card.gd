class_name Card extends Control

@onready var health_text = $Background/Health as Label
@onready var attack_text = $Background/Attack as Label

@export var health := 1:
	set(value):
		health = value
		if health <= 0:
			queue_free()
		if health_text != null:
			health_text.text = str(health)
@export var attack := 1:
	set(value):
		attack = value
		if attack_text != null:
			attack_text.text = str(attack)

func _ready() -> void:
	health_text.text = str(health)
	attack_text.text = str(attack)

var state: CardState = CardState.Hand:
	set(value):
		state = value
		if ability_state == state:
			connect_ability()
		else:
			disconnect_ability()
			
			
var ability_state: CardState = CardState.Board

var is_attacking := false
var is_healing := false

enum CardState {
	Hand,
	Board
}

func activate_ability(event: Event): #override for each invidiual card
	pass

func connect_ability(): #override for each invidiual card
	pass
	
func disconnect_ability(): #override for each invidiual card
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_middle"):
		if state == CardState.Hand:
			state = CardState.Board
			switch_container("Board")
		else:
			state = CardState.Hand
			switch_container("Hand")
			
	if state == CardState.Board:
		if event.is_action_pressed("mouse_left") and !is_healing:
			print("start attack")
			is_attacking = true
		elif event.is_action_pressed("mouse_right") and !is_attacking:
			print("start heal")
			is_healing = true
		elif event.is_action_released("mouse_left") and !is_healing:
			print("end attack")
			var card = find_card_under_mouse()
			if card != null:
				card.health -= self.attack
				var damage_event = DamageEvent.new()
				damage_event.damage_amount = self.attack
				damage_event.damaged_card = card
				damage_event.damaging_card = self
				EventManager.invoke_event(damage_event)
				print("card " + card.name + " took " + str(self.attack) + " damage")
			is_attacking = false
		elif event.is_action_released("mouse_right") and !is_attacking:
			print("end heal")
			var card = find_card_under_mouse()
			if card != null:
				card.health += self.health
				var heal_event = HealEvent.new()
				heal_event.heal_amount = self.health
				heal_event.healed_card = card
				heal_event.healing_card = self
				EventManager.invoke_event(heal_event)
				print("card " + card.name + " healed " + str(self.health) + " health")
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
		print("collision is empty")
		return null
	
func switch_container(container_name: String):
	var container = get_parent().get_parent().get_node(container_name)
	reparent(container, false)
	print("switched card to " + container_name)
	
