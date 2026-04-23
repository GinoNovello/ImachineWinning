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
