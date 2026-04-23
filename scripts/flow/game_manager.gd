extends Node

var player: Player
var opponent: Opponent
var referee: Referee

var opponents = [
	Opponent1
]

var current_opponent_index := 0

func start_new_game():
	player = Player.new()
	opponent = create_opponent()
	referee = Referee.new()

	get_tree().change_scene_to_file("res://Scenes/game/game_scene.tscn")

func start_match():
	get_tree().reload_current_scene()

func create_opponent():
	return opponents[current_opponent_index].new()

func player_won():
	current_opponent_index += 1

func player_lost():
	pass

func go_to_lose_scene():
	get_tree().change_scene_to_file("res://Scenes/results/lose_scene.tscn")

func go_to_win_scene():
	get_tree().change_scene_to_file("res://Scenes/results/win_scene.tscn")
