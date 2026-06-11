class_name StatusEffectData
extends Resource

@export var effectName : String
@export var duration : int = 1
@export var durationTrigger : String = "OnTurnEnd"
@export var effects : Array[EffectData]

func handleEvent(
	eventName : String,
	owner : Character,
	context : Dictionary
):
	pass
