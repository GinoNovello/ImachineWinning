extends Sprite2D
class_name Clock

signal time_over

@export var timeLimit: float = 10.0
@export var fastTickThreshold: float = 3.0
@export var normalTickInterval: float = 1.0
@export var fastTickInterval: float = 0.25

var elapsed: float = 0.0
var running: bool = false
var tickTimer: float = 0.0

@onready var label: Label = $Label
@onready var tick: AudioStreamPlayer = $Tick

func _ready():
	refreshLabel()

func start():
	elapsed = 0.0
	running = true
	tickTimer = currentTickInterval()
	refreshLabel()

func stop():
	running = false

func update(delta: float):
	if not running:
		return

	elapsed += delta
	refreshLabel()

	if not timeIsOver():
		tickTimer -= delta
		if tickTimer <= 0.0:
			playTick()
			tickTimer = currentTickInterval()

	if timeIsOver():
		running = false
		time_over.emit()

func timeIsOver() -> bool:
	return elapsed >= timeLimit

func currentTickInterval() -> float:
	var remaining = timeLimit - elapsed
	if remaining <= fastTickThreshold:
		return fastTickInterval
	return normalTickInterval

func playTick():
	if tick and tick.stream:
		tick.play()

func refreshLabel():
	if label == null:
		return
	var remaining = max(0.0, timeLimit - elapsed)
	var totalSeconds = int(ceil(remaining))
	var minutes = totalSeconds / 60
	var seconds = totalSeconds % 60
	label.text = "%02d:%02d" % [minutes, seconds]
