extends Node
class_name Machine

const MIN_FORCE := 0
const MAX_FORCE := 30

var force: int = 0

func configure(_force: int):
	force = clamp(_force, MIN_FORCE, MAX_FORCE)

func generateForce() -> int:
	return force
