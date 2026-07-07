extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	GameManager.startGame()
	GameManager.playButton()


func _on_button_2_pressed() -> void:
	GameManager.playButton()
	get_tree().quit()
