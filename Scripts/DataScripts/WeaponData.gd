class_name WeaponData extends ItemData

@export var damage : DiceExpression
@export var rangeDistance : int 
@export var type : String

func rollDamage() -> int:
	var value = damage.roll()
	return value
