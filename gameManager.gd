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

var selectedCharacter : Character = null

var score : int = 0
var battlesWon : int = 0

const turnDelay : float = 0.5
var turnTimer : float = 0.0

var gold: int = 0

func _ready():

	randomize()

	startGame()

func _process(delta):

	if currentState != GameState.BATTLE:
		return

	if battleManager == null:
		return

	turnTimer += delta

	if turnTimer >= turnDelay:

		turnTimer = 0.0

		battleManager.nextTurn()

func startGame():

	score = 0
	battlesWon = 0

	Debug.print("=== GAME START ===")

	playerParty = load(
		"res://PlayerParty.tres"
	)

	enemyParty = load(
		"res://EnemyParty.tres"
	)

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
	var baseGold = 20

	var aliveBonus = battleManager.getAliveCount(0) * 5
	var streakBonus = battlesWon * 10

	var earnedGold = baseGold + aliveBonus + streakBonus

	gold += earnedGold

	Debug.print("Gold earned: %d" % earnedGold)
	Debug.print("Total gold: %d" % gold)
	

func checkLevelUp(character: Character) -> void:
	var xp_needed = character.level * 100
	
	while character.xp >= xp_needed:
		character.xp -= xp_needed
		character.level += 1
		xp_needed = character.level * 100
		
		Debug.print("leveled up to %d" % [character.level])

	
func applyXPRewards():
	var baseXP = 30

	for character in playerParty.characters:
		var xpGain = baseXP + battlesWon * 5
		character.xp += xpGain

		checkLevelUp(character)

	Debug.print("XP applied to party")


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

	startBattle()

func startBattle():

	Debug.print(
		"=== BATTLE START ==="
	)

	currentState = GameState.BATTLE

	turnTimer = 0.0

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
	score += earnedScore

	applyRewards()
	applyXPRewards()

	currentState = GameState.VICTORY

	Debug.print("=== VICTORY ===")
	Debug.print("Battle Score: %d" % earnedScore)
	Debug.print("Total Score: %d" % score)
	Debug.print("Battles Won: %d" % battlesWon)

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
