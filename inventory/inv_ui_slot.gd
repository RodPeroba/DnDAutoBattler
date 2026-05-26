extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label

signal item_changed_slot

var slot_data: InvSlot

func update(slot: InvSlot):
	slot_data = slot
	
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount > 1:
			amount_text.visible = true
			amount_text.text = str(slot.amount)
		else:
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
	return true
	#usar essa função para determinar se vc pode ou não dropar o item
	#Exemplo: slot específico de armadura somente armadura pode entrar
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is InvSlot:
		var temp_item = slot_data.item
		var temp_amount = slot_data.amount

		slot_data.item = data.item
		slot_data.amount = data.amount

		data.item = temp_item
		data.amount = temp_amount

		item_changed_slot.emit()
