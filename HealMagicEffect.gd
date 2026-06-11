class_name HealMagicEffect
extends EffectData

func execute(owner : Character, context : Dictionary):
	var allies : Array[Character] = []
	
	for character in owner.battleManager.characters:
		if character.team == owner.team:
			allies.append(character)
	allies.sort_custom(
		func(a,b):
			return a.currentHp < b.currentHp
	)
	
	var amount = min(
		2,
		allies.size()
	)
	
	for i in range(amount):
		allies[i].heal(
			40 * owner.level
		)
