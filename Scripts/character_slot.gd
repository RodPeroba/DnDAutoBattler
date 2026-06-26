extends TextureButton

@onready var item_visual: TextureRect = $CharacterDisplay
@onready var amount_text: Label = $CharacterLabel

var character_data: Character = null

signal character_selected(character: Character)

func update(character: Character):
	character_data = character
	
	if character_data == null:
		item_visual.visible = false
		amount_text.visible = false
		return
	
	item_visual.visible = true
	amount_text.visible = true
	
	item_visual.texture = character_data.sprite
	
	if character_data.characterClass != null:
		amount_text.text = character_data.characterClass.className
	else:
		amount_text.text = "Character"

func _pressed() -> void:
	if character_data != null:
		character_selected.emit(character_data)

func _get_drag_data(at_position: Vector2) -> Variant:
	print("Tentou arrastar character slot: ", character_data)

	if character_data == null:
		return null
	
	var preview_control := Control.new()
	var preview_sprite := Sprite2D.new()
	
	preview_sprite.texture = character_data.sprite
	preview_sprite.position = Vector2(25, 25)
	preview_sprite.modulate.a = 0.5
	preview_sprite.scale = Vector2(0.3, 0.3)
	
	preview_control.add_child(preview_sprite)
	set_drag_preview(preview_control)
	
	return character_data
