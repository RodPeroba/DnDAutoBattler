class_name PassiveData
extends Resource

@export var passiveName : String
@export var trigger : String
@export var effects : Array[EffectData]

func handleEvent(
	eventName : String,
	owner : Character,
	context : Dictionary
):
	if eventName != trigger:
		return
	for effect in effects:
		effect.execute(
			owner,
			context
		)
