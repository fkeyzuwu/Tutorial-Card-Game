extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Table Scenes/player_vs_ai_table.tscn")
