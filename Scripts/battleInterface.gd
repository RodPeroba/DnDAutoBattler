extends Control

@onready var partyMembers: PartyMembers = preload("res://partyMembers.tres")
@onready var charSlots: Array = $BattlePanel/VBoxContainer/GridContainer.get_children()

@export var equipment_ui: Control

var selected_character: Character = null

func _ready() -> void:
	partyMembers.update.connect(update_slots)
	
	for slot in charSlots:
		slot.character_selected.connect(select_character)
	
	for character in partyMembers.slots:
		if character.equipment_inv == null:
			var template: EquipmentInv = preload("res://inventory/equipmentinv.tres")
			character.equipment_inv = template.duplicate(true)
	
	update_slots()
	
	if partyMembers.slots.size() > 0:
		select_character(partyMembers.slots[0])

func update_slots():
	for i in range(min(partyMembers.slots.size(), charSlots.size())):
		charSlots[i].update(partyMembers.slots[i])

func select_character(character: Character):
	if character == null:
		return
	
	if equipment_ui == null:
		print("Equipment UI não foi conectada no Inspector")
		return
	
	selected_character = character
	
	if selected_character.equipment_inv == null:
		var template: EquipmentInv = preload("res://inventory/equipmentinv.tres")
		selected_character.equipment_inv = template.duplicate(true)
	
	equipment_ui.set_inventory(selected_character.equipment_inv)
