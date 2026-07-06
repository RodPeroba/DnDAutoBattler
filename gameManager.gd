extends Node

enum GameState {
	MENU,
	STAGE,
	POSITIONING,
	BATTLE,
	VICTORY,
	DEFEAT,
	GAME_OVER
}

const STAGE_SCREEN = preload("res://Scenes/StageScreen.tscn")
const POSITIONING_SCREEN = preload("res://Scenes/PositioningScreen.tscn")
const BATTLE_SCREEN = preload("res://Scenes/BattleScreen.tscn")
const VICTORY_SCREEN = preload("res://Scenes/VictoryScreen.tscn")
const GAMEOVER_SCREEN = preload("res://Scenes/GameOverScreen.tscn")

var currentState : GameState = GameState.MENU
var currentScreen : Control

var battleManager : BattleManager

var playerParty : PartyData
var enemyParty : PartyData

var encounterGenerator : EncounterGenerator
var enemyDatabase : EnemyDatabase

var selectedCharacter : Character = null

var score : int = 0
var battlesWon : int = 0

const BASE_TURN_DELAY := 0.5

var battleSpeed : float = 1.0
var battlePaused : bool = false

var turnTimer : float = 0.0

var gold: int = 0

var lastGoldReward: int = 0
var lastXPReward: int = 0
var lastScoreReward: int = 0



func _ready():
	randomize()

	startGame()

func _process(delta):
	if currentState != GameState.BATTLE:
		return

	if battleManager == null:
		return

	if battlePaused:
		return

	turnTimer += delta

	var currentDelay = BASE_TURN_DELAY / battleSpeed

	if turnTimer >= currentDelay:

		turnTimer = 0.0

		battleManager.nextTurn()

func setBattleSpeed(speed : float):
	battleSpeed = max(speed, 0.1)

	Debug.print(
		"Battle Speed: %.1fx"
		% battleSpeed
	)

func cycleBattleSpeed():
	match battleSpeed:

		1.0:
			battleSpeed = 2.0

		2.0:
			battleSpeed = 4.0

		4.0:
			battleSpeed = 8.0

		_:
			battleSpeed = 1.0

	Debug.print(
		"Battle Speed: %.0fx"
		% battleSpeed
	)
	
func togglePause():
	battlePaused = !battlePaused

	Debug.print(
		"Battle Paused: %s"
		% battlePaused
	)

func pauseBattle():
	battlePaused = true

func resumeBattle():
	battlePaused = false

func isBattlePaused() -> bool:
	return battlePaused

func getBattleSpeed() -> float:
	return battleSpeed

func resetBattleControls():
	battlePaused = false
	battleSpeed = 1.0
	turnTimer = 0.0

func startGame():

	score = 0
	battlesWon = 0
	
	gold = 0

	lastGoldReward = 0
	lastXPReward = 0
	lastScoreReward = 0

	Debug.print("=== GAME START ===")

	var baseParty = load("res://PlayerParty.tres")
	playerParty = baseParty.duplicate(true)

	var newCharacters : Array[Character] = []

	for character in playerParty.characters:
		newCharacters.append(character.duplicate(true))

	playerParty.characters = newCharacters

	enemyDatabase = load("res://EnemyDatabase.tres")

	encounterGenerator = EncounterGenerator.new(enemyDatabase)

	enemyParty = encounterGenerator.generateParty(battlesWon)

	enterStage()

func changeScreen(
	scene : PackedScene
):

	if currentScreen != null:
		currentScreen.queue_free()

	currentScreen = scene.instantiate()

	var container = (
		get_tree()
		.current_scene
		.get_node("CurrentScreen")
	)

	container.add_child(
		currentScreen
	)
	
	
func applyRewards():
	lastGoldReward = encounterGenerator.getTotalGoldReward()

	gold += lastGoldReward

	Debug.print("Gold earned: %d" % lastGoldReward)
	Debug.print("Total gold: %d" % gold)

func checkLevelUp(character: Character) -> void:
	var xp_needed = character.level * 100
	
	while character.xp >= xp_needed:
		character.xp -= xp_needed
		character.level += 1
		xp_needed = character.level * 100
		
		Debug.print("leveled up to %d" % [character.level])

	
func applyXPRewards():
	lastXPReward = encounterGenerator.getTotalXPReward()

	for character in playerParty.characters:

		character.xp += lastXPReward

		checkLevelUp(character)


func enterStage():

	currentState = GameState.STAGE

	Debug.print(
		"=== STAGE ==="
	)

	Debug.print(
		"Battles Won: %d | Score: %d"
		%
		[
			battlesWon,
			score
		]
	)

	changeScreen(
		STAGE_SCREEN
	)

func enterPositioning():

	currentState = GameState.POSITIONING

	Debug.print(
		"=== POSITIONING ==="
	)

	changeScreen(
		POSITIONING_SCREEN
	)

func confirmPositioning():
	enemyParty = encounterGenerator.generateParty(battlesWon)
	
	startBattle()

func startBattle():

	Debug.print(
		"=== BATTLE START ==="
	)

	currentState = GameState.BATTLE

	resetBattleControls()

	battleManager = BattleManager.new()

	battleManager.battleFinished.connect(
		_onBattleFinished
	)

	changeScreen(
		BATTLE_SCREEN
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

		handleVictory()

	else:

		handleDefeat()

func handleVictory():

	battlesWon += 1

	var earnedScore = calculateBattleScore()

	lastScoreReward = earnedScore

	score += earnedScore

	applyRewards()
	applyXPRewards()

	currentState = GameState.VICTORY

	changeScreen(VICTORY_SCREEN)

func calculateBattleScore() -> int:

	if battleManager == null:
		return 100

	var aliveBonus = (
		battleManager.getAliveCount(0)
		* 25
	)

	var streakBonus = (
		battlesWon
		* 50
	)

	return (
		100
		+ aliveBonus
		+ streakBonus
	)

func continueAfterVictory():

	enterStage()

func handleDefeat():

	currentState = GameState.DEFEAT

	Debug.print(
		"=== DEFEAT ==="
	)

	gameOver()

func gameOver():

	currentState = GameState.GAME_OVER

	Debug.print(
		"=== GAME OVER ==="
	)

	Debug.print(
		"Final Score: %d"
		% score
	)

	Debug.print(
		"Battles Won: %d"
		% battlesWon
	)

	changeScreen(
		GAMEOVER_SCREEN
	)

func restartGame():

	battleManager = null

	startGame()

func resetBattle():

	battleManager = null

	enterPositioning()

func loadBattle(
	playerData : PartyData,
	enemyData : PartyData
):

	playerParty = playerData
	enemyParty = enemyData

	enterPositioning()

func selectCharacter(character : Character) -> void:
	selectedCharacter = character

	if character == null:
		Debug.print("Selected character: none")
		return

	Debug.print("Selected character: %s" % character.characterClass.className)

func createBattleCharacters():

	if playerParty == null:
		return

	if enemyParty == null:
		return

	var team1Positions = [
		Vector2i(12, 8),
		Vector2i(14, 10),
		Vector2i(14, 5),
		Vector2i(10, 8)
	]

	for characterData in playerParty.characters:

		var character : Character = (
			characterData.duplicate(true)
		)

		character.position = (
			characterData.position
		)

		character.team = 0

		character.initialize()

		battleManager.registerCharacter(
			character
		)

	for i in range(
		enemyParty.characters.size()
	):

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
