extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label

signal item_changed_slot

@export var only_accept_specific_type: bool = false
@export var accepted_type: InvItem.ItemType = InvItem.ItemType.NORMAL

var slot_data: InvSlot

func update(slot: InvSlot):
	slot_data = slot
	
	if slot_data == null or slot_data.item == null:
		item_visual.texture = null
		item_visual.visible = false
		amount_text.text = ""
		amount_text.visible = false
		return
	
	item_visual.visible = true
	item_visual.texture = slot_data.item.texture
	
	if slot_data.amount > 1:
		amount_text.visible = true
		amount_text.text = str(slot_data.amount)
	else:
		amount_text.text = ""
		amount_text.visible = false


func _get_drag_data(at_position: Vector2) -> Variant:
	if slot_data == null or slot_data.item == null:
		return
	
	var preview_control := Control.new()
	var preview_sprite := Sprite2D.new()

	preview_sprite.texture = slot_data.item.texture
	preview_sprite.position = Vector2(25, 25)
	preview_sprite.modulate.a = 0.5
	preview_sprite.scale = Vector2(0.3, 0.3)
	preview_control.add_child(preview_sprite)

	set_drag_preview(preview_control)

	return slot_data

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not data is InvSlot:
		return false
	
	if data.item == null:
		return false
	
	if only_accept_specific_type:
		return data.item.item_type == accepted_type
	
	return true
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is InvSlot:
		var temp_item = slot_data.item
		var temp_amount = slot_data.amount

		slot_data.item = data.item
		slot_data.amount = data.amount

		data.item = temp_item
		data.amount = temp_amount

		item_changed_slot.emit()

		var player_inv = preload("res://inventory/playerinv.tres")
		var equipment_inv = preload("res://inventory/equipmentinv.tres")

		player_inv.update.emit()
		equipment_inv.update.emit()
