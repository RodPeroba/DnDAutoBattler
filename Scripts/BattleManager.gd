class_name BattleManager
extends Resource

signal battleFinished(winnerTeam)

var characters : Array[Character] = []
var turnOrder : Array[Character] = []
var currentTurn : int = 0
var round : int = 1

func resetBattle():
	characters.clear()
	turnOrder.clear()
	currentTurn = 0
	round = 1

func registerCharacter(character : Character):
	if not characters.has(character):
		character.battleManager = self
		characters.append(character)

func removeCharacter(character : Character):
	characters.erase(character)
	turnOrder.erase(character)

func startBattle():
	Debug.print("===== BATTLE START =====")

	generateInitiative()
	sortInitiative()

	Debug.print("===== TURN ORDER =====")

	for i in range(turnOrder.size()):

		var character = turnOrder[i]

		Debug.print("%d - %s (%d)" % [
			i + 1,
			character.characterClass.className,
			character.iniciative
		])

	debugBattle()

func generateInitiative():

	var dice = DiceExpression.new(
		[
			DiceTerm.new(1,20)
		]
	)

	for character in characters:

		character.iniciative = (
			dice.roll()
			+
			character.characterClass.iniciativeBonus
		)

func sortInitiative():

	turnOrder = characters.duplicate()

	turnOrder.sort_custom(
		func(a,b):
			return a.iniciative > b.iniciative
	)

func nextTurn():

	if isBattleFinished():

		var winner = getWinningTeam()

		Debug.print(
			"===== BATTLE ENDED ====="
		)

		Debug.print(
			"TEAM %d WINS" % winner
		)

		battleFinished.emit(
			winner
		)

		return

	if turnOrder.is_empty():
		return

	if currentTurn >= turnOrder.size():

		currentTurn = 0

		round += 1

		Debug.print(
			"===== ROUND %d ====="
			% round
		)

	var actor = turnOrder[currentTurn]

	currentTurn += 1

	if actor.currentHp <= 0:
		return

	Debug.print(
		"TURN: %s"
		%
		actor.characterClass.className
	)

	actor.act()

	debugBattle()

	if isBattleFinished():

		var winner = getWinningTeam()

		Debug.print(
			"===== BATTLE ENDED ====="
		)

		Debug.print(
			"TEAM %d WINS" % winner
		)

		battleFinished.emit(
			winner
		)

func isBattleFinished() -> bool:

	var teams = {}

	for character in characters:

		if character.currentHp <= 0:
			continue

		teams[
			character.team
		] = true

	return teams.size() <= 1

func getWinningTeam() -> int:

	var teams = {}

	for character in characters:

		if character.currentHp <= 0:
			continue

		teams[
			character.team
		] = true

	if teams.size() != 1:
		return -1

	return teams.keys()[0]

func isPositionOccupied(
	position : Vector2i
) -> bool:

	for character in characters:

		if character.currentHp <= 0:
			continue

		if character.position == position:
			return true

	return false

func debugBattle():

	Debug.print(
		"===== BATTLE STATE ====="
	)

	for character in characters:

		Debug.print(
			"%s | Team %d | HP %d/%d | Mana %d/%d | Pos %s"
			%
			[
				character.characterClass.className,
				character.team,
				character.currentHp,
				character.maxHp,
				character.currentMana,
				character.maxMana,
				character.position
			]
		)
