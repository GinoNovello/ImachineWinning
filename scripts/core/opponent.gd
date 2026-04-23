extends Node
class_name Opponent

var strength: int
var tolerance: int = 5

func competeAgainst(player: Player, playerForce: int, referee: Referee):
	print("[Opponent] competeAgainst - playerForce: ", playerForce, " strength: ", strength, " tolerance: ", tolerance)
	
	if playerForce < strength:
		print("[Opponent] LOSE - playerForce < strength")
		referee.declareLose(player, self)
		return

	if abs(playerForce - strength) <= tolerance:
		print("[Opponent] WIN - abs(", playerForce - strength, ") <= ", tolerance)
		referee.declareHonestWin(player, self)
		return

	print("[Opponent] CHEATING - force too high")
	referee.declareCheating(player, self)

func onDefeat():
	pass

func onVictory():
	pass
