class_name EncounterGenerator
extends RefCounted

var database : EnemyDatabase

# Guarda os inimigos utilizados no último encontro
# (útil para calcular XP e ouro ao final da batalha)
var lastEncounter : Array[EnemyData] = []


func _init(enemyDatabase : EnemyDatabase):
	database = enemyDatabase


func generateParty(battleNumber : int) -> PartyData:

	lastEncounter.clear()

	var party := PartyData.new()

	var enemyCount := getEnemyCount(battleNumber)

	for i in range(enemyCount):

		var enemyData := chooseEnemy(battleNumber)

		if enemyData == null:
			continue

		lastEncounter.append(enemyData)

		var enemy : Character = enemyData.character.duplicate(true)

		scaleEnemy(enemy, battleNumber)

		party.characters.append(enemy)

	return party


func chooseEnemy(battleNumber : int) -> EnemyData:

	var candidates : Array[EnemyData] = []

	for enemy in database.enemies:

		if enemy.canAppearFromBattle <= battleNumber:

			for i in range(enemy.weight):
				candidates.append(enemy)

	if candidates.is_empty():
		return null

	return candidates.pick_random()


func getEnemyCount(battleNumber : int) -> int:

	if battleNumber < 3:
		return 2

	elif battleNumber < 7:
		return 3

	elif battleNumber < 15:
		return 4

	return 4


func scaleEnemy(enemy : Character, battleNumber : int):

	# aumenta nível lentamente
	enemy.level += int(battleNumber / 2)

	# recalcula atributos
	enemy.setStats()

	# pequeno bônus de HP
	enemy.maxHp = int(enemy.maxHp * (1.0 + battleNumber * 0.05))
	enemy.currentHp = enemy.maxHp

	# pequeno bônus de dano
	enemy.baseDamage = int(enemy.baseDamage * (1.0 + battleNumber * 0.04))

	# bônus de armadura
	enemy.armorValue += int(battleNumber / 5)


func getTotalGoldReward() -> int:

	var total := 0

	for enemy in lastEncounter:
		total += enemy.goldReward

	return total


func getTotalXPReward() -> int:

	var total := 0

	for enemy in lastEncounter:
		total += enemy.xpReward

	return total
