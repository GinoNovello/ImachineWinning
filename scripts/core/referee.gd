extends Node
class_name Referee

var player: Player
var opponent: Opponent

func startMatch(p: Player, o: Opponent):
	player = p
	opponent = o
