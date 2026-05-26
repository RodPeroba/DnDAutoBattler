extends Resource
class_name DiceExpression

@export var dice_terms : Array[DiceTerm] = []

@export var modifier : int = 0

func roll() -> int:

	var total := modifier

	for term in dice_terms:

		for i in term.rolls:

			total += randi_range(
				1,
				term.sides
			)

	return total
