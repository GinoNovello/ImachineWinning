extends Node2D

func _on_restart_pressed() -> void:
	GameManager.start_new_game()

func _on_main_menu_pressed() -> void:
	GameManager.go_to_main_menu()
