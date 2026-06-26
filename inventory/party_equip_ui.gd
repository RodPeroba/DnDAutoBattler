extends Control

@export var equip_slot_scene: PackedScene

@onready var panel: Panel = $Panel
@onready var list_container: HBoxContainer = $Panel/HBoxContainer

var is_open := false

func _ready() -> void:
	visible = false
	is_open = false

	mouse_filter = Control.MOUSE_FILTER_IGNORE

	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.visible = true

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.03, 0.03, 0.03, 0.95)
	style.border_color = Color(0.8, 0.8, 0.8, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	panel.add_theme_stylebox_override("panel", style)

	close()


func refresh() -> void:
	for child in list_container.get_children():
		child.queue_free()

	if GameManager.playerParty == null:
		return

	if equip_slot_scene == null:
		print("ERRO: equip_slot_scene não definido no Party_Equip_UI")
		return

	for character in GameManager.playerParty.characters:
		if character.equipment_inv == null:
			GameManager.selectCharacter(character)

		if character.equipment_inv == null:
			print("ERRO: personagem sem equipment_inv")
			continue

		var character_box := VBoxContainer.new()
		character_box.custom_minimum_size = Vector2(180, 260)
		character_box.add_theme_constant_override("separation", 8)

		var name_label := Label.new()
		name_label.custom_minimum_size = Vector2(180, 28)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		if character.characterClass != null:
			name_label.text = character.characterClass.className
		else:
			name_label.text = "Character"

		character_box.add_child(name_label)

		var equipment_columns := HBoxContainer.new()
		equipment_columns.custom_minimum_size = Vector2(180, 220)
		equipment_columns.add_theme_constant_override("separation", 24)

		var armor_column := VBoxContainer.new()
		armor_column.custom_minimum_size = Vector2(72, 220)
		armor_column.add_theme_constant_override("separation", 8)

		var weapon_column := VBoxContainer.new()
		weapon_column.custom_minimum_size = Vector2(72, 220)
		weapon_column.add_theme_constant_override("separation", 8)

		var equipment_slots = character.equipment_inv.slots

		for i in range(equipment_slots.size()):
			var slot_ui = equip_slot_scene.instantiate()
			slot_ui.custom_minimum_size = Vector2(48, 48)

			if i < 4:
				armor_column.add_child(slot_ui)
			elif i == 4:
				weapon_column.add_child(slot_ui)
			else:
				slot_ui.queue_free()
				continue

			slot_ui.update(equipment_slots[i])

			if slot_ui.has_signal("item_changed_slot"):
				slot_ui.item_changed_slot.connect(_on_equipment_changed.bind(character))

		equipment_columns.add_child(armor_column)
		equipment_columns.add_child(weapon_column)

		character_box.add_child(equipment_columns)
		list_container.add_child(character_box)


func open() -> void:
	refresh()

	visible = true
	show()
	is_open = true

	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 201
	move_to_front()

	panel.size = Vector2(420, 300)
	panel.position = Vector2(40, 180)

	list_container.position = Vector2(24, 24)
	list_container.size = panel.size - Vector2(48, 48)
	list_container.add_theme_constant_override("separation", 32)

	print("PARTY_EQUIP_UI ABERTO")


func close() -> void:
	visible = false
	hide()
	is_open = false

	mouse_filter = Control.MOUSE_FILTER_IGNORE

	print("PARTY_EQUIP_UI FECHADO")


func _on_equipment_changed(character: Character) -> void:
	if character == null:
		return

	if character.equipment_inv != null:
		character.equipment_inv.update.emit()
