class_name WeaponData extends InvItem

@export var damage : DiceExpression
@export var rangeDistance : int 
@export var type : String
@export var attackSound: AudioStream

func rollDamage() -> int:
	var value = damage.roll()
	return value
