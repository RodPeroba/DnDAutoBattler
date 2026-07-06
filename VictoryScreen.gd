extends Control

@export var rewards: Label

func _ready():
	rewards.text = ( 
		"Gold: +%d\n"
		+ "XP: +%d\n"
		+ "Score: +%d\n\n"
		+ "Total Gold: %d\n"
	) % [
		GameManager.lastGoldReward,
		GameManager.lastXPReward,
		GameManager.lastScoreReward,
		GameManager.gold,
	]

func _on_button_pressed() -> void:
	GameManager.enterStage()
