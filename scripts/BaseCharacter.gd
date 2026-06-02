class_name BaseCharacter extends Resource

@export var race : RaceData
@export var characterClass : ClassData
@export var weapon : WeaponData
@export var helmet: ArmorData
@export var chest: ArmorData
@export var legs: ArmorData
@export var boots: ArmorData
@export var level : int = 1
@export var sprite : Texture2D

var team : int = 0
var maxHp : int
var currentHp : int
var currentMana : int
var maxMana : int
var baseDamage : int
var armorValue : int
var speed : int
var iniciative : int
var rangeDistance : int

var position : Vector2i

var target : BaseCharacter
var canAttack : bool

func setStats():
	maxHp = race.baseHealth + characterClass.bonusHealth * level
	currentHp = maxHp
	currentMana = 0
	maxMana = characterClass.mana
	baseDamage = race.baseDamage + characterClass.bonusDamage * level
	armorValue = 0
	if helmet:
		armorValue += helmet.armorValue
	if chest:
		armorValue += chest.armorValue
	if legs:
		armorValue += legs.armorValue
	if boots:
		armorValue += boots.armorValue
	speed = race.baseSpeed
	rangeDistance = weapon.rangeDistance

func findTarget():
	var distance = INF
	for caracter in Manager.characters:
		if caracter.team != self.team:
			var currentDist = self.position.distance_to(caracter.position)
			if currentDist < distance:
				distance = currentDist
				target = caracter
				
func isTargetInRange() -> bool:
	var distance = (
		abs(position.x - target.position.x)
		+
		abs(position.y - target.position.y)
	)
	return distance <= rangeDistance

func moveToRange():
	var distX = (
		target.position.x - position.x
	)
	var distY = (
		target.position.y - position.y
	)
	for i in range(speed):
		if isTargetInRange():
			return
		var nextPosition = position
		if abs(distX) > abs(distY):
			nextPosition.x += sign(distX)
		elif distY != 0:
			nextPosition.y += sign(distY)
		if not Manager.isPositionOccupied(
			nextPosition
		):
			position = nextPosition
		distX = (
			target.position.x - position.x
		)
		distY = (
			target.position.y - position.y
		)

func attack():
	if isTargetInRange():
		target.takeDamage(weapon.rollDamage() + baseDamage)
	return
	
func initialize():
	setStats()
	Manager.register_character(self)
	
func act():
	if target == null or target.currentHp <= 0:
		findTarget()
		return
	moveToRange()
	attack()
	
func takeDamage(value: int):
	currentHp -= int(value * ((100.0-armorValue)/100.0))
	if currentHp <= 0:
		die()

func die():
	Manager.remove_character(self)
