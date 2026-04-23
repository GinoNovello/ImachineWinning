extends Node

var player: Player
var opponent: Opponent
var referee: Referee

var opponents = [
	Opponent1,
	Opponent2,
	Opponent3,
	Opponent4,
	Opponent5,
	Opponent6,
	Opponent7,
	Opponent8,
	Opponent9,
	Opponent10
]

var opponentScenes = [
	"res://Scenes/opponents/opponent1.tscn",
	"res://Scenes/opponents/opponent2.tscn",
	"res://Scenes/opponents/opponent3.tscn",
	"res://Scenes/opponents/opponent4.tscn",
	"res://Scenes/opponents/opponent5.tscn",
	"res://Scenes/opponents/opponent6.tscn",
	"res://Scenes/opponents/opponent7.tscn",
	"res://Scenes/opponents/opponent8.tscn",
	"res://Scenes/opponents/opponent9.tscn",
	"res://Scenes/opponents/opponent10.tscn"
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

func get_current_opponent_scene() -> PackedScene:
	return load(opponentScenes[current_opponent_index])

func player_won():
	current_opponent_index += 1
	
	if current_opponent_index >= opponents.size():
		go_to_win_scene()
	else:
		next_opponent()

func next_opponent():
	opponent = create_opponent()
	get_tree().reload_current_scene()

func player_lost():
	pass

func go_to_lose_scene():
	get_tree().change_scene_to_file("res://Scenes/results/lose_scene.tscn")

func go_to_win_scene():
	get_tree().change_scene_to_file("res://Scenes/results/win_scene.tscn")
