extends TextureButton

@onready var item_visual: TextureRect = $CharacterDisplay
@onready var amount_text: Label = $CharacterLabel
var slot_data: InvItem
var item: Dictionary = {}
signal item_changed_slot

func update(slot: InvItem):
	slot_data = slot
	if !slot:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.texture



func setup(data: Dictionary) -> void:
	item = data
	$TextureRect.texture = load("res://inventory/items/icon_item.tres")
	$Label.text = data.get("name", "")


func _get_drag_data(at_position: Vector2) -> Variant:
	if slot_data == null:
		return

	var preview_control := Control.new()
	var preview_sprite := Sprite2D.new()

	preview_sprite.texture = slot_data.texture
	preview_sprite.position = Vector2(25, 25)
	preview_sprite.modulate.a = 0.5
	preview_sprite.scale = Vector2(0.3, 0.3)
	preview_control.add_child(preview_sprite)

	set_drag_preview(preview_control)

	return slot_data
