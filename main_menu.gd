extends Control


func _on_new_game_pressed() -> void:
	print("New Game Pressed")


func _on_options_pressed() -> void:
	print("Options Pressed")



func _on_exit_game_pressed() -> void:
	get_tree().quit();
