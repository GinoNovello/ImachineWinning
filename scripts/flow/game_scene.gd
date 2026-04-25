extends Node2D

@onready var screens = $UI/Screens
@onready var opponentContainer = $UI/Screens/Arena/OpponentContainer
@onready var configArea = $UI/Screens/ConfigArea
@onready var clock: Clock = $UI/Screens/Arena/Clock
@onready var playerSprite: AnimatedSprite2D = $UI/Screens/Arena/PlayerContainer/AnimatedSprite2D
@onready var roundWinOverlay: CanvasLayer = $RoundWinOverlay
@onready var roundWinTitle: Label = $RoundWinOverlay/Title
@onready var roundWinSubtitle: Label = $RoundWinOverlay/Subtitle

var inArena: bool = true
var opponentVisual: OpponentVisual

func _ready():
	print("Game started")

	var player = GameManager.player
	var opponent = GameManager.opponent
	var referee = GameManager.referee

	referee.force_match.connect(_on_force_match)
	if not GameManager.round_won.is_connected(_on_round_won):
		GameManager.round_won.connect(_on_round_won)

	roundWinOverlay.visible = false

	await _setupRound()

func _setupRound(hide_overlay_before_entrance: bool = false):
	var player = GameManager.player
	var opponent = GameManager.opponent
	var referee = GameManager.referee

	inArena = true
	playerSprite.visible = false

	_loadOpponentVisual()

	if hide_overlay_before_entrance:
		roundWinOverlay.visible = false

	await _playOpponentEntranceAnimation()

	referee.opponentVisual = opponentVisual
	referee.startGame(player, opponent, clock)

	if opponentVisual != null:
		opponentVisual.playGameAnimation()

func _loadOpponentVisual():
	for child in opponentContainer.get_children():
		child.free()

	var opponentScene = GameManager.get_current_opponent_scene()
	var opponentInstance = opponentScene.instantiate()
	opponentContainer.add_child(opponentInstance)
	opponentVisual = opponentInstance as OpponentVisual

func _playOpponentEntranceAnimation():
	if opponentContainer.get_child_count() == 0:
		return

	opponentVisual = opponentContainer.get_child(0) as OpponentVisual
	if opponentVisual == null:
		return

	var tween = opponentVisual.playEntranceAnimation()
	await tween.finished

func _process(delta):
	GameManager.referee.update(delta)

	if Input.is_action_just_pressed("ui_down"):
		show_config()

	if Input.is_action_just_pressed("ui_up"):
		show_match()

	if Input.is_physical_key_pressed(KEY_ENTER) and Input.is_action_just_pressed("ui_accept") and inArena:
		execute_match()

func execute_match():
	var referee = GameManager.referee
	if not referee.isJudging():
		return

	var player = GameManager.player
	var opponent = GameManager.opponent

	playerSprite.visible = true
	
	# Play animation and execute result based on sleeve state
	if player.isSleeveUp():
		if opponentVisual != null and opponentVisual.has_node("WTF"):
			opponentVisual.get_node("AnimatedSprite2D").visible = false
			var wtfSprite = opponentVisual.get_node("WTF")
			wtfSprite.visible = true
			wtfSprite.z_index = 10
		playerSprite.play("UNSLEEVE")
		await playerSprite.animation_finished
		await get_tree().create_timer(1.0).timeout
		playerSprite.visible = false
		# El referee detectará la trampa en checkImmediateConditions
		referee.startMatch(player, opponent)
	else:
		playerSprite.play("SLEEVE")
		await playerSprite.animation_finished
		playerSprite.visible = false
		# Jugar el match normalmente
		player.playAgainst(opponent, referee)

func show_config():
	inArena = false
	configArea.activate()
	var tween = create_tween()
	tween.tween_property(screens, "position:y", -720, 0.15)

func show_match():
	inArena = true
	configArea.deactivate()
	var tween = create_tween()
	tween.tween_property(screens, "position:y", 0, 0.15)

func start_match():
	var player = GameManager.player
	var opponent = GameManager.opponent
	var referee = GameManager.referee

	referee.startMatch(player, opponent)

func _on_force_match():
	if not inArena:
		show_match()
	execute_match()

func _on_round_won():
	roundWinTitle.text = "YOU WIN!"
	roundWinSubtitle.text = "Prepare yourself for the next challenger!"
	roundWinOverlay.visible = true

	await get_tree().create_timer(2.2).timeout

	GameManager.next_opponent()
	await _setupRound(true)
