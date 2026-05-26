extends Panel

const ItemSlot = preload("res://Scenes/character_slot.tscn")

@export var columns: int = 5
@export var slot_count: int = 5

@onready var grid: GridContainer = $VBoxContainer/GridContainer

# Lista de itens (vindo do seu sistema de inventário)
var items: Array[Dictionary] = []


func _ready() -> void:
	grid.columns = columns
	_create_slots()


func _create_slots() -> void:

	for child in grid.get_children():
		child.queue_free()
	
	for i in slot_count:
		var slot = ItemSlot.instantiate()
		grid.add_child(slot)
		


func populate(new_items: Array[Dictionary]) -> void:
	items = new_items
	var slots = grid.get_children()
	
	for i in slots.size():
		if i < items.size():
			slots[i].setup(items[i])
		else:
			slots[i].clear()  # slot vazio


func _on_slot_item_dropped(data: Dictionary, slot_index: int) -> void:
	# Atualiza o estado interno quando itens são movidos
	items[slot_index] = data
	populate(items)
