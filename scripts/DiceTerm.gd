class_name DiceTerm extends Resource

@export var rolls : int = 1
@export var sides : int = 6

func _init(nRolls : int, nSides : int):
	rolls = nRolls
	sides = nSides
