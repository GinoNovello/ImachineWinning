extends Node2D

@onready var sleeve = $PlayerArm/LeftHand
@onready var machine = $PlayerArm/Machine
@onready var needle: Sprite2D = $PlayerArm/Machine/Needle
@onready var tick_sound: AudioStreamPlayer = $PlayerArm/Machine/Needle/TickSound

@export var needle_min_rotation: float = -5 * PI / 12
@export var needle_max_rotation: float = 7 * PI / 12

var _space_held: bool = false
var _needle_force: int = -1
var _needle_tween: Tween
var _in_transition: bool = false
var _in_config: bool = false

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
	
	_in_transition = true

	if player.isSleeveUp():
		sleeve.play("IDLEMANGAOFFTOROLLSLEEVEON")
		sleeve.animation_finished.connect(_on_animation_finished.bind(true), CONNECT_ONE_SHOT)
	else:
		sleeve.play("IDLEMANGAONTOROLLSLEEVEOFF")
		sleeve.animation_finished.connect(_on_animation_finished.bind(false), CONNECT_ONE_SHOT)

func _on_animation_finished(was_sleeve_up: bool):
	var player = GameManager.player
	
	if was_sleeve_up:
		player.rollDownSleeve()
	else:
		player.rollUpSleeve()
	
	_in_transition = false
	update_visuals()

func exit_config():
	get_parent().get_parent().get_parent().show_match()

func update_visuals():
	if _in_transition or _in_config:
		print("update_visuals skipped - _in_transition: ", _in_transition, " _in_config: ", _in_config)
		return
		
	# Check if currently playing CONFIG animation - if so, don't change it
	if sleeve.animation == "CONFIG":
		print("Currently playing CONFIG, keeping it")
		_in_config = true
		return
		
	var player = GameManager.player
	print("update_visuals playing idle - sleeveUp: ", player.isSleeveUp())
	if player.isSleeveUp():
		sleeve.play("IDLEMANGAOFF")
	else:
		sleeve.play("IDLEMANGAON")

func increase_force():
	if GameManager.player.can_configure():
		if sleeve.animation == "CONFIG" or sleeve.animation == "CONFIGTOINCREASEFORCE" or sleeve.animation == "CONFIGTODECREASEFORCE":
			sleeve.play("CONFIGTOINCREASEFORCE")
		else:
			sleeve.play("IDLETOCONFIG")
			sleeve.animation_finished.connect(_on_config_animation_finished.bind("CONFIG"), CONNECT_ONE_SHOT)
	GameManager.player.increase_machine_force()

func decrease_force():
	if GameManager.player.can_configure():
		if sleeve.animation == "CONFIG" or sleeve.animation == "CONFIGTOINCREASEFORCE" or sleeve.animation == "CONFIGTODECREASEFORCE":
			sleeve.play("CONFIGTODECREASEFORCE")
		else:
			sleeve.play("IDLETOCONFIG")
			sleeve.animation_finished.connect(_on_config_animation_finished.bind("CONFIG"), CONNECT_ONE_SHOT)
	GameManager.player.decrease_machine_force()

func _on_config_animation_finished(next_state: String):
	print("_on_config_animation_finished - setting _in_config = true")
	_in_transition = false
	_in_config = true
	sleeve.play("CONFIG")

func _on_force_animation_finished():
	print("_on_force_animation_finished - returning to CONFIG")
	_in_transition = false
	_in_config = true
	sleeve.play("CONFIG")

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
