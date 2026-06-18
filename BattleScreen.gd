extends Control

@export var battleInfo : Label
@export var combatLog : RichTextLabel

var connectedToLog : bool = false

func _ready():

	updateInfo()

	if GameManager.battleManager != null:
		connectBattleManager()

func _process(delta):

	if GameManager.battleManager == null:
		return

	if !connectedToLog:
		connectBattleManager()

	updateInfo()

func connectBattleManager():

	if GameManager.battleManager == null:
		return

	if GameManager.battleManager.logAdded.is_connected(
		_onLogAdded
	):
		return

	GameManager.battleManager.logAdded.connect(
		_onLogAdded
	)

	connectedToLog = true

	combatLog.clear()

	for line in GameManager.battleManager.combatLog:

		combatLog.append_text(
			line + "\n"
		)

func updateInfo():

	if GameManager.battleManager == null:

		battleInfo.text = "No battle running"

		return

	var bm = GameManager.battleManager

	var actorName = "-"

	if bm.currentActor != null:

		actorName = (
			bm.currentActor
			.characterClass
			.className
		)

	battleInfo.text = (
		"Round: %d\n" +
		"Turn: %s\n" +
		"Blue Team: %d alive\n" +
		"Red Team: %d alive"
	) % [
		bm.round,
		actorName,
		bm.getAliveCount(0),
		bm.getAliveCount(1)
	]

func _onLogAdded(
	message : String
):

	combatLog.append_text(
		message + "\n"
	)

	combatLog.scroll_to_line(
		combatLog.get_line_count()
	)
