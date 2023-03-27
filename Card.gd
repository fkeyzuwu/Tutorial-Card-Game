@tool
##Card instance class for in game board use.
class_name Card extends Control

var card_owner: String #player or ai or the other player

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

@export_category("FX")
@export var heal_particle_effect: PackedScene
@export var damage_particle_effect: PackedScene

func _ready() -> void:
	state = CardState.Hand

func update_card_data(_card_data: CardData):
	health = _card_data.health
	attack = _card_data.attack
	picture.texture = _card_data.texture
	background_color.color = _card_data.background_color
	description.text = _card_data.description

var state: CardState = CardState.None:
	set(value):
		for ability in card_data.abilities:
			ability.card = self
			for condition in ability.conditions:
				condition.ability = ability
				condition.handle_listening(state, value)
				
			ability.handle_listening(state, value)
			
		state = value

enum CardState {
	None,
	Hand,
	Board
}

func damage_card(card: Card):
	card.health -= self.attack
	card.spawn_particle(damage_particle_effect)
	var damage_event = DamageEvent.new(self.attack, card, self)
	EventManager.invoke_event(damage_event)
	
func heal_card(card: Card):
	card.health += self.health
	card.spawn_particle(heal_particle_effect)
	var heal_event = HealEvent.new(self.health, card, self)
	EventManager.invoke_event(heal_event)

func kill_card():
	EventManager.invoke_event(MonsterDiedEvent.new(self))
	queue_free()

func spawn_particle(particle_effect: PackedScene):
	var particle = particle_effect.instantiate() as GPUParticles2D
	particle.position = position + $Background.size / 2
	particle.rotation = rotation
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
