class_name HealEffect
extends EffectData

@export var amount : int

func execute(owner : Character, context : Dictionary):
	owner.currentHp = min(
		owner.currentHp + amount,
		owner.maxHp
	)
	debugText = "%s heals for %d" %[owner.characterClass.className, amount]
	super.execute(owner, context)
