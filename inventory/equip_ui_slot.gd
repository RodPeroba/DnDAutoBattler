extends Control

var inv: EquipmentInv
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

@export var start_closed = true

var is_open = false

func _ready() -> void:
	custom_minimum_size = Vector2(420, 80)
	for slot in slots:
		slot.item_changed_slot.connect(_on_item_changed_slot)
	
	update_slots()
	
	if start_closed:
		close()
	else:
		open()

func set_inventory(new_inv: EquipmentInv):
	if inv != null and inv.update.is_connected(update_slots):
		inv.update.disconnect(update_slots)
	
	inv = new_inv
	
	if inv != null:
		inv.update.connect(update_slots)
	
	update_slots()

func update_slots():
	if inv == null:
		for slot in slots:
			slot.update(null)
		return
	
	for i in range(slots.size()):
		if i < inv.slots.size():
			slots[i].update(inv.slots[i])
		else:
			slots[i].update(null)

func open():
	self.visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	is_open = true

func close():
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	is_open = false

func _process(delta: float) -> void:
	pass

func _on_item_changed_slot():
	if inv != null:
		inv.update.emit()
