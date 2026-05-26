extends Node2D

const TILE_SIZE := 32
const GRID_SIZE := 16

func _ready():

	randomize()

	create_test_characters()

func _process(delta):

	queue_redraw()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Manager.step()

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
	
	var archer = ClassData.new()
	
	archer.className = "Archer"
	archer.bonusHealth = 5
	archer.bonusDamage = 5

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
	

	var character1 = BaseCharacter.new()

	character1.race = race
	character1.characterClass = warrior
	character1.weapon = sword
	character1.armor = armor

	character1.position = Vector2i(2, 8)

	character1.team = 0

	character1.initialize()
	
	var character3 = BaseCharacter.new()

	character3.race = race
	character3.characterClass = archer
	character3.weapon = bow
	character3.armor = armor

	character3.position = Vector2i(2, 5)

	character3.team = 0

	character3.initialize()

	var character2 = BaseCharacter.new()

	character2.race = race
	character2.characterClass = archer
	character2.weapon = bow
	character2.armor = armor

	character2.position = Vector2i(14, 10)

	character2.team = 1

	character2.initialize()
	
	var character4 = BaseCharacter.new()

	character4.race = race
	character4.characterClass = warrior
	character4.weapon = sword
	character4.armor = armor

	character4.position = Vector2i(12, 8)

	character4.team = 1

	character4.initialize()

func _draw():

	draw_grid()

	draw_characters()

func draw_grid():

	for x in range(GRID_SIZE + 1):

		draw_line(
			Vector2(x * TILE_SIZE, 0),
			Vector2(
				x * TILE_SIZE,
				GRID_SIZE * TILE_SIZE
			),
			Color.WHITE
		)

	for y in range(GRID_SIZE + 1):

		draw_line(
			Vector2(0, y * TILE_SIZE),
			Vector2(
				GRID_SIZE * TILE_SIZE,
				y * TILE_SIZE
			),
			Color.WHITE
		)

func draw_characters():

	for character in Manager.characters:

		var pos = Vector2(
			character.position
			* TILE_SIZE
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
