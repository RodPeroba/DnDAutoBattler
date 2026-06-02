class_name DecimatesEffect
extends EffectData

@export var damage : int = 40 

func execute(owner : Character, context : Dictionary):
	var target : Character = context["target"]
	
	if target == null:
		return
	
	print("%s decimates %s for %d" % [owner.characterClass.className, target.characterClass.className,damage])
	
	target.takeDamage(
		damage,
		owner
	)
