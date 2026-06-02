class_name ActiveData
extends Resource

@export var abilityName : String
@export var effects : Array[EffectData]

func canUse(owner : Character) -> bool:
	return owner.currentMana >= owner.maxMana

func use(owner : Character, context : Dictionary):
	if not canUse(owner):
		return
		
	owner.currentMana = 0
	
	for effect in effects:
		effect.execute(owner, context)
