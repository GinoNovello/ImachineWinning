extends Node2D

@onready var sleeve = $PlayerArm/Sleeve
@onready var machine = $PlayerArm/Machine
@onready var force_label = $ForceLabel

func _process(_delta):
	handle_input()
	update_visuals()
	update_force_label()

func handle_input():
	if Input.is_action_just_pressed("ui_accept"):
		toggle_sleeve()

	if Input.is_action_just_pressed("ui_up"):
		exit_config()

	if Input.is_action_just_pressed("ui_right"):
		increase_force()

	if Input.is_action_just_pressed("ui_left"):
		decrease_force()

func toggle_sleeve():
	var player = GameManager.player

	if player.isSleeveUp():
		player.rollDownSleeve()
	else:
		player.rollUpSleeve()

func exit_config():
	get_parent().get_parent().get_parent().show_match()

func update_visuals():
	var player = GameManager.player

	sleeve.visible = not player.isSleeveUp()
	machine.visible = player.isSleeveUp()

func increase_force():
	GameManager.player.increase_machine_force()

func decrease_force():
	GameManager.player.decrease_machine_force()

func update_force_label():
	var player = GameManager.player
	force_label.text = str(player.machine.generateForce())
