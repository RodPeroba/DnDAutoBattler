class_name Character
extends Resource

@export var race : RaceData
@export var characterClass : ClassData

@export var equipment_inv: EquipmentInv

@export var weapon : WeaponData
@export var helmet: ArmorData
@export var chest: ArmorData
@export var legs: ArmorData
@export var boots: ArmorData
@export var level : int = 1
@export var sprite : Texture2D

var passives : Array[PassiveData]
var activeAbility : ActiveData
@export var chosenAbility : int = 0
var statuses : Array[StatusEffectData]
var xp : int = 0
var battleManager : BattleManager
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
var target : Character

var damage_flash_time : float = 0.0
var attack_animation_time : float = 0.0
var attack_direction : Vector2 = Vector2.ZERO

var projectile_animation_time : float = 0.0
var projectile_start : Vector2i
var projectile_target : Vector2i

func initialize():
	setStats()

func setStats():
	maxHp = race.bonusHealth * level + characterClass.bonusHealth * level + characterClass.baseHealth
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
	activeAbility = characterClass.activeAbilities[chosenAbility]

func emitEvent(eventName : String, context : Dictionary = {}):
	for passive in passives:
		passive.handleEvent(eventName, self, context)
	for status in statuses:
		status.handleEvent(eventName, self, context)
		
	updateStatuses(eventName)
	
func addStatus(status : StatusEffectData):
	statuses.append(
		status.duplicate(true)
	)
	
func updateStatuses(eventName : String):
	for status in statuses.duplicate():
		if status.durationTrigger != eventName:
			continue
			
		status.duration -= 1
		
		if status.duration <= 0:
			
			Debug.print("%s lost %s" %[characterClass.className, status.effectName])
			
			statuses.erase(status)

func act():
	emitEvent("OnTurnStart")
	
	if target == null or target.currentHp <= 0:
		findTarget()
		
	if target == null:
		return
	
	moveToRange()
	if (activeAbility != null and activeAbility.canUse(self)):
		useAbility()
	else:
		if isTargetInRange():
			attack()
			currentMana = min(currentMana + characterClass.manaPerAttack, maxMana)
	emitEvent("OnTurnEnd")

func findTarget():
	var closestDistance = INF
	target = null

	for character in battleManager.characters:
		if character == self: continue
		if character.team == team: continue
		if character.currentHp <= 0: continue
		
		var distance = position.distance_to(character.position)
		
		if distance < closestDistance:
			closestDistance = distance
			target = character
	
	if target != null:
		Debug.print("%s targets %s" % [characterClass.className, target.characterClass.className])
	
func isTargetInRange() -> bool:
	if target == null:
		return false
	
	var distance = abs(position.x - target.position.x) + abs(position.y - target.position.y)
	return distance <= rangeDistance

func isRanged() -> bool:
	return rangeDistance > 1
	
func startMeleeAnimation():

	if target == null:
		return

	attack_animation_time = 0.15

	attack_direction = (target.position - position)

func startProjectileAnimation():

	if target == null:
		return

	projectile_animation_time = 0.25

	projectile_start = position
	projectile_target = target.position

func moveToRange():
	if target == null:
		return
	
	for i in range(speed):
		if isTargetInRange():
			return
	
		var distX = target.position.x - position.x
		var distY = target.position.y - position.y
		var nextPosition = position
		
		if abs(distX) >= abs(distY):
			if distX != 0:
				nextPosition.x += sign(distX)
		else:
			if distY != 0:
				nextPosition.y += sign(distY)
		
		if !battleManager.isPositionOccupied(nextPosition):
			position = nextPosition
			Debug.print("%s moved to %s" % [characterClass.className, position])

func attack():
	if target == null:
		return
	
	var context = {
		"target": target,
		"damage": weapon.rollDamage() + baseDamage
	}
	
	emitEvent("OnAttack", context)
	
	if isRanged():
		startProjectileAnimation()
	else:
		startMeleeAnimation()
	
	Debug.print("%s attacks %s for %d" % [
		characterClass.className,
		target.characterClass.className,
		context["damage"]
	])
	
	target.takeDamage(context["damage"], self)
	
func useAbility():
	if activeAbility == null:
		return
	var context = {"target": target}
	Debug.print("%s uses %s" % [characterClass.className, activeAbility.abilityName])
	activeAbility.use(self, context)

func takeDamage(value : int, attacker : Character = null):
	var context = {
		"attacker": attacker,
		"damage": value
	}
	
	emitEvent("OnReceiveDamage", context)
	
	var finalDamage = int(context["damage"] * ((100.0 - armorValue) / 100.0))
	currentHp -= finalDamage
	
	Debug.print("%s takes %d damage (%d HP left)" % [
		characterClass.className,
		finalDamage,
		currentHp
	])
	
	if currentHp <= 0:
		die(attacker)
	else:
		damage_flash_time = 0.25

func heal(amount : int):
	currentHp = min(
		maxHp,
		currentHp + amount
	)
	
	Debug.print(
		"%s heals %d HP"
		%
		[
			characterClass.className,
			amount
		]
	)

func die(killer : Character = null):
	currentHp = 0
	
	Debug.print("%s died" % characterClass.className)
	
	emitEvent("OnDeath", {"killer": killer})
	
	if killer != null:
		killer.emitEvent("OnKill", {"target": self})
	
	battleManager.removeCharacter(self)
