extends Node

enum GameState{
	MENU,
	BATTLE,
	VICTORY,
	DEFEAT
}

var currentState : GameState = GameState.MENU

var battleManager : BattleManager

var playerParty : PartyData
var enemyParty : PartyData

func _ready():
	randomize()
	startGame()

func startGame():
	print(load("res://Spear.tres"))
	
	
	playerParty = load(
		"res://PlayerParty.tres"
	)

	enemyParty = load(
		"res://EnemyParty.tres"
	)

	Debug.print("=== GAME START ===")

	startBattle()

func startBattle():

	Debug.print("=== BATTLE START ===")

	currentState = GameState.BATTLE

	battleManager = BattleManager.new()

	battleManager.battleFinished.connect(
		_onBattleFinished
	)

	createBattleCharacters()

	battleManager.startBattle()

func nextStep():

	if currentState != GameState.BATTLE:
		return

	if battleManager == null:
		return

	battleManager.nextTurn()

func _onBattleFinished(
	winnerTeam : int
):

	if winnerTeam == 0:

		currentState = GameState.VICTORY

		Debug.print(
			"=== TEAM 0 WINS ==="
		)

	else:

		currentState = GameState.DEFEAT

		Debug.print(
			"=== TEAM 1 WINS ==="
		)

func resetBattle():

	battleManager = null

	startBattle()

func createBattleCharacters():

	var team0Positions = [
		Vector2i(2,8),
		Vector2i(2,5),
		Vector2i(2,11),
		Vector2i(4,8)
	]

	var team1Positions = [
		Vector2i(12,8),
		Vector2i(14,10),
		Vector2i(14,5),
		Vector2i(10,8)
	]

	for i in range(playerParty.characters.size()):

		var character : Character = (
			playerParty.characters[i]
			.duplicate(true)
		)

		character.team = 0

		if i < team0Positions.size():
			character.position = (
				team0Positions[i]
			)

		character.initialize()

		battleManager.registerCharacter(
			character
		)

	for i in range(enemyParty.characters.size()):

		var character : Character = (
			enemyParty.characters[i]
			.duplicate(true)
		)

		character.team = 1

		if i < team1Positions.size():
			character.position = (
				team1Positions[i]
			)

		character.initialize()

		battleManager.registerCharacter(
			character
		)

func loadBattle(
	playerData : PartyData,
	enemyData : PartyData
):

	playerParty = playerData
	enemyParty = enemyData

	startBattle()
