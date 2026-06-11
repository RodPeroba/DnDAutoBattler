class_name PreciseArrowEffect
extends EffectData

func execute(owner : Character, context : Dictionary):
	var status = PreciseArrowStatus.new()
	
	status.effectName = "Precise Arrow"
	status.duration = 2 + owner.level
	status.bonusDamage = 8 * owner.level
	
	owner.addStatus(status)
