class_name HuntEffect
extends EffectData

func execute(owner : Character,context : Dictionary):
	var target : Character = null
	var lowestHp = INF
	
	for character in owner.battleManager.characters:
		
		if character.team == owner.team:
			continue
			
		var distance = (
			abs(character.position.x - owner.position.x)
			+
			abs(character.position.y - owner.position.y)
		)
		if distance > 4:
			continue
			
		if character.currentHp < lowestHp:
			lowestHp = character.currentHp
			target = character
			
	if target == null:
		return
		
	owner.target = target
	owner.moveToRange()
	
	
	if owner.isTargetInRange():
		owner.attack()
