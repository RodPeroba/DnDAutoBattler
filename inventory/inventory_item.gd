extends Resource

class_name InvItem

@export var name: String = ""
@export var texture: Texture

enum ItemType { NORMAL, HELMET, CHEST, LEGS, BOOTS }
@export var item_type: ItemType = ItemType.NORMAL
