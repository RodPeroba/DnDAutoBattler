class_name PreciseArrowStatus
extends StatusEffectData

@export var bonusDamage : int

func handleEvent(eventName : String, owner : Character,context : Dictionary):
	if eventName != "OnAttack":
		return
	
	context["damage"] += bonusDamage
