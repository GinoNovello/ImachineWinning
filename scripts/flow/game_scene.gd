extends Node2D

var player
var opponent
var referee

func _ready():
	print("Game started")
	setup_match()

func setup_match():
	player = Player.new()
	opponent = Opponent1.new()
	referee = Referee.new()

	referee.startMatch(player, opponent)

func load_opponent_view():
	var scene = load("res://scenes/opponents/opponent1.tscn")
	var view = scene.instantiate()
	$OpponentContainer.add_child(view)
