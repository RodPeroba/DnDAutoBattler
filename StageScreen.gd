extends Control

@export var info: Label

func _ready() -> void:
	update_info()

func update_info() -> void:
	info.text = "Ouro Total: %d" % GameManager.gold

func _on_button_pressed() -> void:
	GameManager.enterPositioning()
