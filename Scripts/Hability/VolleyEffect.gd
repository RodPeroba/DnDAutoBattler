class_name VolleyEffect
extends EffectData

@export var damage : int = 15

func execute(owner : Character,context : Dictionary):
	for character in owner.battleManager.characters:
		if character.team == owner.team:
			continue
	
		var distance = (
			abs(owner.position.x - character.position.x)
			+
			abs(owner.position.y - character.position.y)  
		)
	
		if distance > owner.rangeDistance:
			continue
		
		debugText = "%s hits %s with Volley for %d" % [owner.characterClass.className, character.characterClass.className, damage]
		super.execute(owner, context)
		
		character.takeDamage(
			damage,
			owner
		)
