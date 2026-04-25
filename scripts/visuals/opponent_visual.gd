extends Node2D
class_name OpponentVisual

@onready var sprite: Sprite2D = $Sprite2D
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

var finalPosition: Vector2
var startOffsetX: float = 400.0
var walkBobAmount: float = 8.0
var entranceDuration: float = 1.5

func _ready():
	finalPosition = sprite.position
	_setupOffscreen()

func _setupOffscreen():
	sprite.position.x = finalPosition.x + startOffsetX

func playEntranceAnimation():
	var tween = create_tween()
	tween.set_parallel(false)
	
	var steps = 8
	var stepDuration = entranceDuration / steps
	var distancePerStep = startOffsetX / steps
	
	for i in range(steps):
		var targetX = finalPosition.x + startOffsetX - (distancePerStep * (i + 1))
		var bobOffset = walkBobAmount if i % 2 == 0 else -walkBobAmount
		var targetY = finalPosition.y + bobOffset
		
		tween.tween_property(sprite, "position", Vector2(targetX, targetY), stepDuration)
	
	tween.tween_property(sprite, "position", finalPosition, 0.1)
	
	return tween

func playGameAnimation():
	sprite.visible = false
	animatedSprite.visible = true
	animatedSprite.z_index = 10  # Poner adelante de todo
	animatedSprite.play("READY")
