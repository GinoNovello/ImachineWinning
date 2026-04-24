extends Node
class_name Referee

var player: Player
var opponent: Opponent

var match_started: bool = false

func _init():
	pass

func startMatch(_player: Player, _opponent: Opponent):
	player = _player
	opponent = _opponent

	match_started = true
	checkImmediateConditions()

func checkImmediateConditions():
	print("[Referee] checkImmediateConditions - sleeveUp: ", player.isSleeveUp())
	if player.isSleeveUp():
		print("[Referee] CHEATING detected - sleeve is up!")
		declareCheating(player, opponent)

func update(_delta):
	if not match_started:
		return

	# TODO: time system not implemented yet
	# if timeIsOver:
	#     declareTimeLoss(player)

func judgeMatch(_player: Player, _opponent: Opponent, playerForce: int):
	_opponent.competeAgainst(_player, playerForce, self)

# --- DECISIONS ---

func declareHonestWin(_player: Player, _opponent: Opponent):
	_opponent.onDefeat()
	_player.win()

func declareLose(_player: Player, _opponent: Opponent):
	_opponent.onVictory()
	_player.lose()

func declareCheating(_player: Player, _opponent: Opponent):
	_player.caughtCheating()

# TODO:
# func declareTimeLoss(player: Player):
#     player.caughtCheatingAfterTimeIsOver()
