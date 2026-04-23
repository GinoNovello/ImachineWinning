extends Node

func start_new_game():
	print("Loading GameScene...")
	get_tree().change_scene_to_file("res://Scenes/game/game_scene.tscn")
