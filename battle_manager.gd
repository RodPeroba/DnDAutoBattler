extends Node2D

var character_array: Array[CharacterBody2D]
var warrior = preload("res://warrior_scene.tscn") 

@export var inv: Inv
@export var item: InvItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	var W1 = warrior.instantiate()
	var W2 = warrior.instantiate()
	var W3 = warrior.instantiate()

	character_array.append(W1)
	character_array.append(W2)
	character_array.append(W3)
	
	W1.generate_initiative()
	W2.generate_initiative()
	W3.generate_initiative()
	
	print("%d %d %d",
	[character_array[0].initiative,
	character_array[1].initiative,
	character_array[2].initiative])

	character_array.sort_custom(initiative_sort)

	print("%d %d %d",
	[character_array[0].initiative,
	character_array[1].initiative,
	character_array[2].initiative])

func initiative_sort(a, b):
	return a.initiative > b.initiative

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	inv.insert(item)
