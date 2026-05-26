extends Control

@export var world_node: Node2D  # referência ao node principal

func _can_drop_data(at_position, data):
	return data.has("scene")

func _drop_data(at_position, data):
	var item = data["scene"].instantiate()
	world_node.add_child(item)
	
	# Converte a posição da UI para o espaço do mundo
	item.global_position = get_global_mouse_position()
