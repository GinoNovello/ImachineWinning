extends Node2D

@onready var sleeve = $PlayerArm/Sleeve
@onready var machine = $PlayerArm/Machine
@onready var needle: Sprite2D = $PlayerArm/Machine/Needle
@onready var tick_sound: AudioStreamPlayer = $PlayerArm/Machine/Needle/TickSound

@export var needle_min_rotation: float = -7 * PI / 12
@export var needle_max_rotation: float = PI / 2

var _space_held: bool = false
var _needle_force: int = -1
var _needle_tween: Tween

const HOLD_REPEAT_DELAY: float = 0.35
const HOLD_REPEAT_INTERVAL: float = 0.07
var _hold_dir: int = 0
var _hold_time: float = 0.0
var _hold_next_tick: float = 0.0

var isActive: bool = false

func _ready():
	if GameManager.player:
		var force = GameManager.player.machine.generateForce()
		needle.rotation = _force_to_rotation(force)
		_needle_force = force

func _process(delta):
	if isActive:
		handle_input(delta)
	update_visuals()
	update_needle()

func activate():
	isActive = true

func deactivate():
	isActive = false

func handle_input(delta: float):
	if Input.is_physical_key_pressed(KEY_SPACE) and not _space_held:
		toggle_sleeve()
		_space_held = true
	elif not Input.is_physical_key_pressed(KEY_SPACE):
		_space_held = false

	if Input.is_action_just_pressed("ui_up"):
		exit_config()

	handle_force_hold(delta)

func handle_force_hold(delta: float):
	var dir := 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1

	if dir == 0 or dir != _hold_dir:
		_hold_dir = dir
		_hold_time = 0.0
		_hold_next_tick = HOLD_REPEAT_DELAY
		if dir > 0 and Input.is_action_just_pressed("ui_right"):
			increase_force()
		elif dir < 0 and Input.is_action_just_pressed("ui_left"):
			decrease_force()
		return

	_hold_time += delta
	while _hold_time >= _hold_next_tick:
		if _hold_dir > 0:
			increase_force()
		else:
			decrease_force()
		_hold_next_tick += HOLD_REPEAT_INTERVAL

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

	if tick_sound and tick_sound.stream:
		tick_sound.play()

	if _needle_tween:
		_needle_tween.kill()
	_needle_tween = create_tween()
	_needle_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_needle_tween.tween_property(needle, "rotation", _force_to_rotation(force), 0.15)

func _force_to_rotation(force: int) -> float:
	var t = float(force) / float(Machine.MAX_FORCE)
	return lerp(needle_min_rotation, needle_max_rotation, t)
