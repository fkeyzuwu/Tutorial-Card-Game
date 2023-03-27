@tool
extends EditorPlugin

const card_maker = preload("res://addons/card_maker/card_maker.tscn")
var card_maker_instance: CardMaker

func _enter_tree() -> void:
	card_maker_instance = card_maker.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(card_maker_instance)
	_make_visible(false)

func _exit_tree() -> void:
	if card_maker_instance:
		card_maker_instance.queue_free()

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	if card_maker_instance:
		card_maker_instance.visible = visible

func _get_plugin_name() -> String:
	return "Card Maker"

func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")
