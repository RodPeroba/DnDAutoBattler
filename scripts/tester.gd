extends Node2D

const TILE_SIZE := 32
const GRID_SIZE := 16

var battleManager : BattleManager

func _ready():

	randomize()

	battleManager = BattleManager.new()

	create_test_characters()

func _process(delta):
	queue_redraw()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		battleManager.nextTurn()

func create_test_characters():

	var race = RaceData.new()
	race.raceName = "Human"
	race.baseHealth = 100
	race.baseDamage = 5
	race.baseSpeed = 3

	var warrior = ClassData.new()
	warrior.className = "Warrior"
	warrior.bonusHealth = 20
	warrior.bonusDamage = 3
	warrior.mana = 15
	var archer = ClassData.new()
	archer.className = "Archer"
	archer.bonusHealth = 5
	archer.bonusDamage = 5
	archer.mana = 10

	var armor = ArmorData.new()
	armor.armorValue = 10

	var dice = DiceExpression.new()

	var term = DiceTerm.new()
	term.rolls = 1
	term.sides = 8

	dice.dice_terms.append(term)

	var sword = WeaponData.new()
	sword.damage = dice
	sword.rangeDistance = 1

	var bow = WeaponData.new()
	bow.damage = dice
	bow.rangeDistance = 5

	# PASSIVES

	var regenPassive = PassiveData.new()
	regenPassive.passiveName = "Regeneration"
	regenPassive.trigger = "OnTurnStart"

	var regenEffect = HealEffect.new()
	regenEffect.amount = 10

	regenPassive.effects.append(regenEffect)

	var sniperPassive = PassiveData.new()
	sniperPassive.passiveName = "Sniper"
	sniperPassive.trigger = "OnAttack"

	var sniperEffect = DistanceBonusDamageEffect.new()
	sniperEffect.damagePerTile = 2

	sniperPassive.effects.append(sniperEffect)

	var extraAttackPassive = PassiveData.new()
	extraAttackPassive.passiveName = "Bloodlust"
	extraAttackPassive.trigger = "OnKill"

	var extraAttackEffect = ExtraAttackEffect.new()

	extraAttackPassive.effects.append(extraAttackEffect)

	# ACTIVE ABILITIES

	var executeAbility = ActiveData.new()
	executeAbility.abilityName = "Decimate	"

	var executeEffect = DecimatesEffect.new()
	executeEffect.damage = 40

	executeAbility.effects.append(
		executeEffect
	)

	var volleyAbility = ActiveData.new()
	volleyAbility.abilityName = "Volley"

	var volleyEffect = VolleyEffect.new()
	volleyEffect.damage = 15

	volleyAbility.effects.append(
		volleyEffect
	)

	# WARRIOR TEAM 0

	var character1 = Character.new()

	character1.race = race
	character1.characterClass = warrior
	character1.weapon = sword
	character1.armor = armor

	character1.position = Vector2i(2, 8)
	character1.team = 0

	character1.passives.append(regenPassive)
	character1.activeAbility = executeAbility

	character1.initialize()

	battleManager.registerCharacter(character1)

	# ARCHER TEAM 0

	var character2 = Character.new()

	character2.race = race
	character2.characterClass = archer
	character2.weapon = bow
	character2.armor = armor

	character2.position = Vector2i(2, 5)
	character2.team = 0

	character2.passives.append(sniperPassive)
	character2.activeAbility = volleyAbility

	character2.initialize()

	battleManager.registerCharacter(character2)

	# ARCHER TEAM 1

	var character3 = Character.new()

	character3.race = race
	character3.characterClass = archer
	character3.weapon = bow
	character3.armor = armor

	character3.position = Vector2i(14, 10)
	character3.team = 1

	character3.passives.append(sniperPassive)
	character3.activeAbility = volleyAbility 

	character3.initialize()

	battleManager.registerCharacter(character3)

	# WARRIOR TEAM 1

	var character4 = Character.new()

	character4.race = race
	character4.characterClass = warrior
	character4.weapon = sword
	character4.armor = armor

	character4.position = Vector2i(12, 8)
	character4.team = 1

	character4.passives.append(extraAttackPassive)
	character4.activeAbility = executeAbility

	character4.initialize()

	battleManager.registerCharacter(character4)

	battleManager.startBattle()

func _draw():
	draw_grid()
	draw_characters()

func draw_grid():

	for x in range(GRID_SIZE + 1):

		draw_line(
			Vector2(x * TILE_SIZE, 0),
			Vector2(x * TILE_SIZE, GRID_SIZE * TILE_SIZE),
			Color.WHITE
		)

	for y in range(GRID_SIZE + 1):

		draw_line(
			Vector2(0, y * TILE_SIZE),
			Vector2(GRID_SIZE * TILE_SIZE, y * TILE_SIZE),
			Color.WHITE
		)

func draw_characters():

	for character in battleManager.characters:

		var pos = Vector2(
			character.position * TILE_SIZE
		)
  
		var color = Color.BLUE

		if character.team == 1:
			color = Color.RED

		draw_rect(
			Rect2(
				pos,
				Vector2(TILE_SIZE, TILE_SIZE)
			),
			color
		)
