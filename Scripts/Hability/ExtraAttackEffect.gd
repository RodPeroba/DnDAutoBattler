class_name ExtraAttackEffect
extends EffectData

func execute(owner : Character, context : Dictionary):
	owner.act()
	print("%s attacks again" % owner.characterClass.className)
