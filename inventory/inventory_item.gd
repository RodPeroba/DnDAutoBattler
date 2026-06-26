class_name InvItem
extends Resource



@export var name: String = ""
@export var texture: Texture

enum ItemType { NORMAL, HELMET, CHEST, LEGS, BOOTS, WEAPON }
@export var item_type: ItemType = ItemType.NORMAL
