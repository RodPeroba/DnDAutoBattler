class_name FireballEffect
extends EffectData

func execute(owner : Character,context : Dictionary):
	var target : Character = context["target"]
	
	if target == null:
		return
		
	target.takeDamage(
		50 * owner.level,
		owner
	)
