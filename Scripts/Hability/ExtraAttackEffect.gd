class_name ExtraAttackEffect
extends EffectData

func execute(owner : Character, context : Dictionary):
	owner.act()
	debugText = "%s attacks again" % owner.characterClass.className
	super.execute(owner, context)
