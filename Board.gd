extends HBoxContainer

func _on_child_entered_tree(node: Node) -> void:
	DataManager.board_cards.append(node as Card)

func _on_child_exiting_tree(node: Node) -> void:
	DataManager.board_cards.erase(node as Card)
