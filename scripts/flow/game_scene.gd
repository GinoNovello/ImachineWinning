extends Node2D

@onready var screens = $UI/Screens
@onready var opponentContainer = $UI/Screens/Arena/OpponentContainer

func _ready():
	print("Game started")

	var player = GameManager.player
	var opponent = GameManager.opponent
	var referee = GameManager.referee

	_playOpponentEntranceAnimation()
	referee.startMatch(player, opponent)

func _playOpponentEntranceAnimation():
	var opponentVisual = opponentContainer.get_child(0) as OpponentVisual
	if opponentVisual:
		opponentVisual.playEntranceAnimation()

func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		show_config()

	if Input.is_action_just_pressed("ui_up"):
		show_match()

func show_config():
	var tween = create_tween()
	tween.tween_property(screens, "position:y", -720, 0.15)

func show_match():
	var tween = create_tween()
	tween.tween_property(screens, "position:y", 0, 0.15)

	start_match()

func start_match():
	var player = GameManager.player
	var opponent = GameManager.opponent
	var referee = GameManager.referee

	referee.startMatch(player, opponent)
