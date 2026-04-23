extends Node
class_name Referee

var player: Player
var opponent: Opponent

func startMatch(player: Player, opponent: Opponent):
	self.player = player
	self.opponent = opponent
