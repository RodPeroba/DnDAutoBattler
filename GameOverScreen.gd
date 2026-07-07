extends Control

func _on_button_pressed() -> void:
	GameManager.playButton()
	GameManager.startGame()


func _on_button_2_pressed() -> void:
	GameManager.playButton()
	GameManager.enterMenu()
