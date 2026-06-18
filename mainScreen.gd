extends Control

@export var scoreLabel : Label
@export var winsLabel : Label

func _process(delta):

	scoreLabel.text = (
		"Score: %d"
		% GameManager.score
	)

	winsLabel.text = (
		"Wins: %d"
		% GameManager.battlesWon
	)
