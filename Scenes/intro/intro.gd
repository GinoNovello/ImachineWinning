extends Control

var imagePaths := [
	"res://Images/Background.png",
	"res://Images/ConfigBackground.png",
	"res://Images/Table.png"
]

var currentImageIndex := 0

@onready var imageDisplay: TextureRect = $ImageDisplay
@onready var hintLabel: Label = $HintLabel


func _ready() -> void:
	displayCurrentImage()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		advanceToNextImage()
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		advanceToNextImage()


func displayCurrentImage() -> void:
	var texture := load(imagePaths[currentImageIndex]) as Texture2D
	imageDisplay.texture = texture


func advanceToNextImage() -> void:
	currentImageIndex += 1

	if currentImageIndex >= imagePaths.size():
		GameManager.start_game_scene()
		return

	displayCurrentImage()
