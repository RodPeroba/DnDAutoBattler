class_name BattleManager
extends Resource

signal battleFinished(winnerTeam)
signal logAdded(message : String)

var characters : Array[Character] = []
var turnOrder : Array[Character] = []

var currentTurn : int = 0
var round : int = 1

var currentActor : Character

var combatLog : Array[String] = []

func resetBattle():

	characters.clear()
	turnOrder.clear()

	currentTurn = 0
	round = 1

	currentActor = null

	combatLog.clear()

func loga(text : String):

	combatLog.append(text)

	logAdded.emit(text)

	Debug.print(text)

	if combatLog.size() > 200:
		combatLog.pop_front()

func registerCharacter(character : Character):

	if not characters.has(character):

		character.battleManager = self

		characters.append(character)

func removeCharacter(character : Character):

	characters.erase(character)

	turnOrder.erase(character)

func startBattle():

	loga("===== BATTLE START =====")

	generateInitiative()

	sortInitiative()

	loga("===== TURN ORDER =====")

	for i in range(turnOrder.size()):

		var character = turnOrder[i]

		loga(
			"%d - %s (%d)"
			%
			[
				i + 1,
				character.characterClass.className,
				character.iniciative
			]
		)

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

		loga(
			"===== BATTLE ENDED ====="
		)

		loga(
			"TEAM %d WINS"
			% winner
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

		loga(
			"===== ROUND %d ====="
			% round
		)

	var actor = turnOrder[currentTurn]

	currentTurn += 1

	if actor == null:
		return

	if actor.currentHp <= 0:
		return

	currentActor = actor

	loga(
		"TURN: %s"
		%
		actor.characterClass.className
	)

	actor.act()

	debugBattle()

	if isBattleFinished():

		var winner = getWinningTeam()

		loga(
			"===== BATTLE ENDED ====="
		)

		loga(
			"TEAM %d WINS"
			% winner
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

func getAliveCount(
	team : int
) -> int:

	var count := 0

	for character in characters:

		if character.team != team:
			continue

		if character.currentHp <= 0:
			continue

		count += 1

	return count

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

	loga(
		"===== BATTLE STATE ====="
	)

	for character in characters:

		loga(
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
