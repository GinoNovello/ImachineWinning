# 📘 Imachine Winning – Technical Documentation

## 🎯 Objective

Define a simple, extensible, and object-oriented architecture for **Imachine Winning**, ensuring:

* Low coupling
* High cohesion
* Expressive, domain-driven code
* No procedural centralization

---

# 🧠 Game Concept

The player configures a machine to compete in an arm-wrestling match against an opponent.

The outcome depends on:

* `playerForce`
* `opponentStrength`

### Possible Outcomes

* ✅ Honest win
* ❌ Loss
* ⚠️ Win with cheating detected
* ⏱️ Loss due to timeout (cheating detected)

---

# 🧱 Architecture (OOP)

## Core Classes

```
Player
Machine
Opponent
├── Opponent1
│   └── OpponentStory
├── Opponent2
│   └── OpponentStory
└── ...
Referee
Clock
```

---

# ⚙️ Design Principles

## 1. Tell, Don’t Ask

Objects should perform actions, not expose state.

❌ Avoid:

```gdscript
if opponent.evaluate(force) == "win":
```

✅ Prefer:

```gdscript
player.playAgainst(opponent, referee)
```

---

## 2. No String-Based Logic

❌ Avoid:

```gdscript
return "win"
```

✅ Prefer:

* Behavior-driven methods (`win()`, `lose()`)
* Delegation between objects

---

## 3. Avoid Unnecessary Getters

❌ Avoid:

```gdscript
clock.getTime()
```

✅ Prefer:

```gdscript
clock.timeIsOver()
```

---

# 🧩 Responsibilities

---

## 🎮 Player

Represents the user and initiates gameplay actions.

```gdscript
class_name Player

var machine: Machine

func configureMachine(minForce: int, maxForce: int):
	machine.configure(minForce, maxForce)

func playAgainst(opponent: Opponent, referee: Referee):
	var force = machine.generateForce()
	referee.judgeMatch(self, opponent, force)

func win():
	# trigger animations and advance
	pass

func lose():
	# trigger animations and return to menu
	pass

func caughtCheating():
	# cheating detected
	pass

func caughtCheatingAfterTimeIsOver():
	# timeout cheating detected
	pass
```

---

## 🤖 Machine

Encapsulates force configuration and generation.

```gdscript
class_name Machine

var minForce: int
var maxForce: int

func configure(minForce: int, maxForce: int):
	self.minForce = minForce
	self.maxForce = maxForce

func generateForce() -> int:
	return randi_range(minForce, maxForce)
```

---

## 🧍 Opponent

Encapsulates match rules.

```gdscript
class_name Opponent

var strength: int
var tolerance: int = 5

func competeAgainst(player: Player, playerForce: int, referee: Referee):
	if playerForce < strength:
		referee.declareLose(player, self)
		return

	if abs(playerForce - strength) <= tolerance:
		referee.declareHonestWin(player, self)
		return

	referee.declareCheating(player, self)

func onDefeat():
	# play lose animation
	pass

func onVictory():
	# play win animation
	pass
```

---

## 🧍‍♂️ Specific Opponents

```gdscript
class_name Opponent1
extends Opponent

func _init():
	strength = 10
	tolerance = 3
```

➡ Only define data, never duplicate logic.

---

## 📖 OpponentStory

Narrative + visual data.

```gdscript
class_name OpponentStory

var description: String
var image: Texture2D
```

---

## ⏱️ Clock

Controls time flow.

```gdscript
class_name Clock

var timeLimit: float
var elapsed: float = 0

func start():
	elapsed = 0

func update(delta):
	elapsed += delta

func timeIsOver() -> bool:
	return elapsed >= timeLimit
```

---

## ⚖️ Referee

Coordinates the match. Does NOT contain game rules.

```gdscript
class_name Referee

var clock: Clock
var player: Player
var opponent: Opponent

func startMatch(player: Player, opponent: Opponent):
	self.player = player
	self.opponent = opponent
	clock.start()

func update(delta):
	clock.update(delta)

	if clock.timeIsOver():
		declareTimeLoss(player)

func judgeMatch(player: Player, opponent: Opponent, playerForce: int):
	opponent.competeAgainst(player, playerForce, self)
```

---

## 🧾 Referee Decisions

```gdscript
func declareHonestWin(player: Player, opponent: Opponent):
	opponent.onDefeat()
	player.win()

func declareLose(player: Player, opponent: Opponent):
	opponent.onVictory()
	player.lose()

func declareCheating(player: Player, opponent: Opponent):
	player.caughtCheating()

func declareTimeLoss(player: Player):
	player.caughtCheatingAfterTimeIsOver()
```

---

# 🔄 Game Flow

```
Referee.startMatch(player, opponent)

(loop)
  Referee.update()

Player.configureMachine()

Player.playAgainst(opponent, referee)

→ Referee.judgeMatch()
→ Opponent.competeAgainst()
→ Referee.declareX()
→ Player / Opponent react
```

---

# 🧾 Coding Conventions

## Naming

| Element   | Convention | Example       |
| --------- | ---------- | ------------- |
| Variables | camelCase  | playerForce   |
| Functions | camelCase  | playAgainst() |
| Classes   | PascalCase | Referee       |
| Constants | UPPER_CASE | MAX_FORCE     |

---

# 🧼 Best Practices

## ✔ Expressive Methods

```gdscript
player.playAgainst(opponent, referee)
```

---

## ✔ No String Logic

```gdscript
if result == "win" # ❌ forbidden
```

---

## ✔ No God Objects

**Referee must NOT:**

* Calculate force
* Define rules
* Contain game logic

Only coordinates.

---

## ✔ Encapsulation

* Rules → `Opponent`
* Flow → `Referee`
* Actions → `Player`

---

## ✔ Low Coupling

* Player does not know rules
* Opponent does not control Player
* Referee coordinates without owning logic

---

# 🧪 Example

```gdscript
player.configureMachine(8, 12)

referee.startMatch(player, opponent)

player.playAgainst(opponent, referee)
```

---

# ❗ Design Decision

The Player MUST NOT decide outcomes.

❌ Avoid:

```gdscript
player.winHonestly()
```

Because:

* Player does not know rules
* Violates separation of responsibilities

---
