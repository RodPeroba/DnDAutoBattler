extends Control

@onready var inv: EquipmentInv = preload("res://inventory/equipmentinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inv.update.connect(update_slots)
	
	for slot in slots:
		slot.item_changed_slot.connect(_on_item_changed_slot)
	
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func open():
	self.visible = true
	is_open = true

func close():
	visible = false
	is_open = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("b"):
		if is_open:
			close()
		else:
			open()

func _on_item_changed_slot():
	inv.update.emit()
