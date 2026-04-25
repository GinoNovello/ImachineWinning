extends Node2D

@onready var sleeve = $PlayerArm/Sleeve
@onready var machine = $PlayerArm/Machine
@onready var needle: Sprite2D = $PlayerArm/Machine/Needle

@export var needle_min_rotation: float = -7 * PI / 12
@export var needle_max_rotation: float = PI / 2

var _space_held: bool = false
var _needle_force: int = -1
var _needle_tween: Tween

var isActive: bool = false

func _ready():
	if GameManager.player:
		var force = GameManager.player.machine.generateForce()
		needle.rotation = _force_to_rotation(force)
		_needle_force = force

func _process(_delta):
	if isActive:
		handle_input()
	update_visuals()
	update_needle()

func activate():
	isActive = true

func deactivate():
	isActive = false

func handle_input():
	if Input.is_physical_key_pressed(KEY_SPACE) and not _space_held:
		toggle_sleeve()
		_space_held = true
	elif not Input.is_physical_key_pressed(KEY_SPACE):
		_space_held = false

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

func update_needle():
	var force = GameManager.player.machine.generateForce()
	if force == _needle_force:
		return
	_needle_force = force

	if _needle_tween:
		_needle_tween.kill()
	_needle_tween = create_tween()
	_needle_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_needle_tween.tween_property(needle, "rotation", _force_to_rotation(force), 0.15)

func _force_to_rotation(force: int) -> float:
	var t = float(force) / float(Machine.MAX_FORCE)
	return lerp(needle_min_rotation, needle_max_rotation, t)
