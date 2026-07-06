extends Panel

var item_visual: Sprite2D

func _ready():
	item_visual = get_node("CenterContainer/Panel/item_display")

func update(item: InvItem):

	if item == null:
		item_visual.texture = null
		item_visual.visible = false
		return

	item_visual.visible = true
	item_visual.texture = item.texture
