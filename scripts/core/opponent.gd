extends Node
class_name Opponent

var strength: int
var tolerance: int = 5

func competeAgainst(player: Player, playerForce: int, referee: Referee):
	if playerForce < strength:
		referee.declareLose(player, self)
		return

	if abs(playerForce - strength) <= tolerance:
		referee.declareHonestWin(player, self)
		return

	referee.declareCheating(player, self)

func onDefeat():
	pass

func onVictory():
	pass
