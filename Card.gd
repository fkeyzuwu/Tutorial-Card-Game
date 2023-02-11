class_name Card extends Control

@onready var health_text = $Background/Health as Label
@onready var attack_text = $Background/Attack as Label

@export var heal_particle_effect: PackedScene
@export var damage_particle_effect: PackedScene

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

var state: CardState = CardState.Hand

var is_attacking := false
var is_healing := false

enum CardState {
	Hand,
	Board
}

func activate_ability(): #override for each invidiual card
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
			is_attacking = true
		elif event.is_action_pressed("mouse_right") and !is_attacking:
			is_healing = true
		elif event.is_action_released("mouse_left") and !is_healing:
			var card = find_card_under_mouse()
			if card != null:
				card.take_damage(self.attack)
			is_attacking = false
		elif event.is_action_released("mouse_right") and !is_attacking:
			var card = find_card_under_mouse()
			if card != null:
				card.recieve_heal(self.health)
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
	var container = get_parent().get_parent().get_node(container_name)
	reparent(container, false)
	
func recieve_heal(amount: int):
	health += amount
	var particle = heal_particle_effect.instantiate() as GPUParticles2D
	particle.position = global_position - Vector2(0, 50) #show effect on monster
	particle.rotation = rotation
	particle.emitting = true
	get_tree().current_scene.add_child(particle)

func take_damage(amount: int):
	health -= amount
	var particle = damage_particle_effect.instantiate() as GPUParticles2D
	particle.position = global_position - Vector2(0, 50) #show effect on monster
	particle.rotation = rotation
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
