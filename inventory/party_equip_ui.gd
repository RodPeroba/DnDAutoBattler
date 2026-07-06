extends Control

@export var equip_slot_scene: PackedScene

@onready var panel: PanelContainer = $Panel
@onready var list_container: HBoxContainer = $Panel/HBoxContainer

var is_open := false

func _ready() -> void:
	visible = false
	is_open = false

	mouse_filter = Control.MOUSE_FILTER_IGNORE

	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.visible = true

	var style := StyleBoxFlat.new()
	style.bg_color = Color("dca464")
	style.border_color = Color(0.8, 0.8, 0.8, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	panel.add_theme_stylebox_override("panel", style)

	close()


func refresh():

	for child in list_container.get_children():
		child.queue_free()

	if GameManager.playerParty == null:
		return

	for character in GameManager.playerParty.characters:

		var character_box := VBoxContainer.new()
		character_box.custom_minimum_size = Vector2(180, 260)
		character_box.add_theme_constant_override("separation", 8)

		var name_label := Label.new()
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.text = character.characterClass.className

		character_box.add_child(name_label)

		var equipment_columns := HBoxContainer.new()
		equipment_columns.add_theme_constant_override("separation", 24)

		var armor_column := VBoxContainer.new()
		armor_column.add_theme_constant_override("separation", 8)

		var weapon_column := VBoxContainer.new()
		weapon_column.add_theme_constant_override("separation", 8)

		# ---------- Helmet ----------
		var helmet_slot = equip_slot_scene.instantiate()
		helmet_slot.update(character.helmet)
		armor_column.add_child(helmet_slot)

		# ---------- Chest ----------
		var chest_slot = equip_slot_scene.instantiate()
		chest_slot.update(character.chest)
		armor_column.add_child(chest_slot)

		# ---------- Legs ----------
		var legs_slot = equip_slot_scene.instantiate()
		legs_slot.update(character.legs)
		armor_column.add_child(legs_slot)

		# ---------- Boots ----------
		var boots_slot = equip_slot_scene.instantiate()
		boots_slot.update(character.boots)
		armor_column.add_child(boots_slot)

		# ---------- Weapon ----------
		var weapon_slot = equip_slot_scene.instantiate()
		weapon_slot.update(character.weapon)
		weapon_column.add_child(weapon_slot)

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
	panel.position = Vector2(70, 20)

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
