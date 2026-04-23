extends Node2D

var player
var opponent
var referee

@onready var screens = $UI/Screens

func _ready():
	print("Game started")
	setup_match()

func setup_match():
	player = Player.new()
	opponent = Opponent1.new()
	referee = Referee.new()

	referee.startMatch(player, opponent)

func load_opponent_view():
	var scene = load("res://scenes/opponents/opponent1.tscn")
	var view = scene.instantiate()
	$OpponentContainer.add_child(view)

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		show_config()

	if Input.is_action_just_pressed("ui_up"):
		show_match()

func show_config():
	var tween = create_tween()
	tween.tween_property(screens, "position:y", -720, 0.3)

func show_match():
	var tween = create_tween()
	tween.tween_property(screens, "position:y", 0, 0.3)
