extends Node
class_name Player

var machine: Machine
var sleeveUp := false

func _init():
	machine = Machine.new()

# --- SLEEVE ---

func rollUpSleeve():
	sleeveUp = true

func rollDownSleeve():
	sleeveUp = false

func isSleeveUp() -> bool:
	return sleeveUp

# --- CONFIG ---

func increase_machine_force():
	if not can_configure():
		return

	# Play animation logic here - you'll need to reference the config_area sleeve
	machine.configure(machine.generateForce() + 1)

func decrease_machine_force():
	if not can_configure():
		return

	machine.configure(machine.generateForce() - 1)

func can_configure() -> bool:
	return isSleeveUp()

# --- GAMEPLAY ---

func playAgainst(opponent: Opponent, referee: Referee):
	var force = machine.generateForce()
	print("[Player] playAgainst - force: ", force, " sleeveUp: ", sleeveUp)
	referee.judgeMatch(self, opponent, force)

func win():
	GameManager.player_won()

func lose():
	GameManager.player_lost()
	GameManager.go_to_lose_scene()

func caughtCheating():
	GameManager.go_to_cheating_lose_scene()

func caughtForExcessiveForce():
	GameManager.go_to_excessive_force_lose_scene()
