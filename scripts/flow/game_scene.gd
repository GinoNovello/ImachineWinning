extends Node2D

@onready var screens = $UI/Screens
@onready var opponentContainer = $UI/Screens/Arena/OpponentContainer
@onready var configArea = $UI/Screens/ConfigArea
@onready var clock: Clock = $UI/Screens/Arena/Clock
@onready var playerSprite: AnimatedSprite2D = $UI/Screens/Arena/PlayerContainer/AnimatedSprite2D

var inArena: bool = true
var opponentVisual: OpponentVisual

func _ready():
	print("Game started")

	var player = GameManager.player
	var opponent = GameManager.opponent
	var referee = GameManager.referee

	referee.force_match.connect(_on_force_match)

	_loadOpponentVisual()
	await _playOpponentEntranceAnimation()
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
		playerSprite.play("UNSLEEVE")
		await playerSprite.animation_finished
		referee.declareCheating(player, opponent)
	else:
		playerSprite.play("SLEEVE")
		await playerSprite.animation_finished
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
