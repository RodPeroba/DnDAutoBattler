class_name PartyData
extends Resource

@export var characters : Array[Character]
@export var equipment_template: EquipmentInv = preload("res://inventory/equipmentinv.tres")

func initialize_equipment_inventories():
	for character in characters:
		if character.equipment_inv == null:
			character.equipment_inv = equipment_template.duplicate(true)
