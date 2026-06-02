class_name DistanceBonusDamageEffect
extends EffectData

@export var damagePerTile : int = 2

func execute(owner : Character,context : Dictionary):
	var target : Character = context["target"]
	
	var distance = (
		abs(owner.position.x - target.position.x)
		+
		abs(owner.position.y - target.position.y)
	)
	
	context["damage"] += (
		distance * damagePerTile
	)
	print("%s do %d extra damage" % [owner.characterClass.className, distance * damagePerTile])
