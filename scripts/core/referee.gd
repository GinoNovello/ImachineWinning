extends Node
class_name Referee

signal force_match

var player: Player
var opponent: Opponent
var clock: Clock
var opponentVisual: OpponentVisual

var match_started: bool = false

func isJudging() -> bool:
	return match_started

func _init():
	pass

func startGame(_player: Player, _opponent: Opponent, _clock: Clock):
	player = _player
	opponent = _opponent
	clock = _clock

	if not clock.time_over.is_connected(_on_time_over):
		clock.time_over.connect(_on_time_over)

	clock.start()
	match_started = true

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

func update(delta):
	if not match_started:
		return

	if clock:
		clock.update(delta)

func judgeMatch(_player: Player, _opponent: Opponent, playerForce: int):
	_opponent.competeAgainst(_player, playerForce, self)

func _on_time_over():
	force_match.emit()

# --- DECISIONS ---

func declareHonestWin(_player: Player, _opponent: Opponent):
	match_started = false
	if opponentVisual != null:
		opponentVisual.playLoseAnimation()
		await opponentVisual.animatedSprite.animation_finished
	_opponent.onDefeat()
	_player.win()

func declareLose(_player: Player, _opponent: Opponent):
	match_started = false
	if opponentVisual != null:
		opponentVisual.playWinAnimation()
		await opponentVisual.animatedSprite.animation_finished
	_opponent.onVictory()
	_player.lose()

func declareCheating(_player: Player, _opponent: Opponent):
	match_started = false
	_player.caughtCheating()
