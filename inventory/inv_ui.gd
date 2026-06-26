extends Control

@onready var inv: Inv = preload("res://inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open := false

func _ready() -> void:
	visible = false
	is_open = false

	mouse_filter = Control.MOUSE_FILTER_STOP

	if inv != null:
		inv.update.connect(update_slots)

	for slot in slots:
		if slot.has_signal("item_changed_slot"):
			slot.item_changed_slot.connect(_on_item_changed_slot)

	update_slots()


func update_slots() -> void:
	if inv == null:
		return

	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])


func open() -> void:
	update_slots()

	visible = true
	show()
	is_open = true

	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 200
	move_to_front()

	print("INV_UI ABERTO | visible:", visible, " global_position:", global_position, " size:", size)


func close() -> void:
	visible = false
	hide()
	is_open = false

	mouse_filter = Control.MOUSE_FILTER_IGNORE

	print("INV_UI FECHADO")


func _on_item_changed_slot() -> void:
	if inv != null:
		inv.update.emit()
