extends Control

@onready var partyMembers = preload("res://partyMembers.tres")
@onready var charSlots: Array = $BattlePanel/VBoxContainer/GridContainer.get_children()

func _ready() -> void:
	partyMembers.update.connect(update_slots)
	
	for slot in charSlots:
		slot.item_changed_slot.connect(_on_item_changed_slot)
	
	update_slots()

func update_slots():
	for i in range(min(partyMembers.slots.size(), charSlots.size())):
		print(partyMembers.slots[i].get_class())
		charSlots[i].update(partyMembers.slots[i])

func _on_item_changed_slot():
	partyMembers.update.emit()
