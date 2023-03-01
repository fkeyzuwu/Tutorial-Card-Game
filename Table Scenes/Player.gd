class_name Player extends Node2D

var is_holding_card := false
var current_card: Card
var current_card_container: Control

var is_attacking := false
var is_healing := false

var is_my_turn:
	get: 
		return GameManager.game_state == GameManager.GameState.PlayerTurn


func _input(event: InputEvent) -> void:
	if !is_my_turn:
		return
	
	if event.is_action_pressed("end_turn"):
		GameManager.switch_game_state(GameManager.GameState.AiTurn)
	
	if event.is_action_pressed("mouse_left"):
		var card = find_card_under_mouse()
		if card == null or card.card_owner != "Player":
			return
			
		if card.state == Card.CardState.Hand:
			is_holding_card = true
			current_card = card
			print("holding card")
		elif card.state == Card.CardState.Board:
			if is_healing:
				return
			is_attacking = true
			current_card = card
			print("attacking")
	elif event.is_action_released("mouse_left"):
		if current_card == null:
			is_attacking = false
			return
		
		if current_card.state == Card.CardState.Hand:
			var container = find_container_under_mouse()
			if container != null and container.name == "Player Board":
				GameManager.play_card_at_location(current_card, container)
			
			is_holding_card = false
			print("stopped holding card")
		elif current_card.state == Card.CardState.Board:
			if is_healing:
				is_attacking = false
				return
			var card = find_card_under_mouse()
			if can_card_be_attacked(card):
				current_card.damage_card(card)
				print("stopped attacking")
				is_attacking = false
				
		current_card = null
	
	if event.is_action_pressed("mouse_right"):
		if is_attacking:
			return
			
		var card = find_card_under_mouse()
		if card == null:
			return
			
		if card.state == Card.CardState.Board:
			is_healing = true
			current_card = card
			
	elif event.is_action_released("mouse_right"):
		if current_card == null:
			is_healing = false
			return
		
		if is_attacking:
			is_healing = false
			return
		
		var card = find_card_under_mouse()
		if can_card_be_healed(card):
			current_card.heal_card(card)
			is_healing = false
			
func find_card_under_mouse() -> Card:
	var space = get_world_2d().direct_space_state
	var mouse_position = get_global_mouse_position()
	var query = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 1
	query.position = mouse_position
	var collision = space.intersect_point(query, 1)
	if !collision.is_empty():
		var card = collision[0].collider.get_parent().get_parent() as Card
		return card
	else:
		return null

func find_container_under_mouse() -> Control:
	var space = get_world_2d().direct_space_state
	var mouse_position = get_global_mouse_position()
	var query = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 2
	query.position = mouse_position
	var collision = space.intersect_point(query, 1)
	if !collision.is_empty():
		var container = collision[0].collider.get_parent().get_child(0) as Control #rent().get_child(1)should get board/hand
		return container
	else:
		return null

func can_card_be_attacked(card: Card) -> bool:
	return card != null and card.state == Card.CardState.Board and is_attacking and card.card_owner == "AIPlayer"
	
func can_card_be_healed(card: Card) -> bool:
	return card != null and card.state == Card.CardState.Board and is_healing and card.card_owner == "Player"
