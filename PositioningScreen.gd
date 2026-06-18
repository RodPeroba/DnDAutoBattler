extends Control

@export var boardView : BoardView
@export var infoLabel : Label
@export var confirmButton : Button

var selectedCharacter : Character

var validDeployPositions : Array[Vector2i] = [
	Vector2i(0,4),
	Vector2i(0,5),
	Vector2i(0,6),
	Vector2i(0,7),
	Vector2i(1,4),
	Vector2i(1,5),
	Vector2i(1,6),
	Vector2i(1,7),
	Vector2i(2,4),
	Vector2i(2,5),
	Vector2i(2,6),
	Vector2i(2,7)
]

func _ready():

	updateInfo()

	confirmButton.disabled = true

	for i in range(GameManager.playerParty.characters.size()):

		var character = GameManager.playerParty.characters[i]

		if i < validDeployPositions.size():

			character.position = validDeployPositions[i]

	boardView.queue_redraw()

func _input(event):

	if GameManager.currentState != GameManager.GameState.POSITIONING:
		return

	if event is InputEventMouseButton:

		if !event.pressed:
			return

		if event.button_index != MOUSE_BUTTON_LEFT:
			return

		var tile = boardView.screenToTile(
			event.position
		)

		handleTileClick(tile)

func handleTileClick(tile : Vector2i):

	# Seleciona personagem
	for character in GameManager.playerParty.characters:

		if character.position == tile:

			selectedCharacter = character

			updateInfo()

			return

	# Move personagem selecionado
	if selectedCharacter == null:
		return

	if !validDeployPositions.has(tile):
		return

	if isTileOccupied(tile):
		return

	selectedCharacter.position = tile

	boardView.queue_redraw()

	updateInfo()

	checkReady()

func isTileOccupied(
	tile : Vector2i
) -> bool:

	for character in GameManager.playerParty.characters:

		if character == selectedCharacter:
			continue

		if character.position == tile:
			return true

	return false

func checkReady():

	confirmButton.disabled = !allCharactersPositioned()

func allCharactersPositioned() -> bool:

	var occupied := {}

	for character in GameManager.playerParty.characters:

		if !validDeployPositions.has(
			character.position
		):
			return false

		var key = str(character.position)

		if occupied.has(key):
			return false

		occupied[key] = true

	return true

func updateInfo():

	if selectedCharacter == null:

		infoLabel.text = (
			"Select a character"
		)

		return

	infoLabel.text = (
		"Selected: %s\n"
		+ "Level %d\n"
		+ "HP %d"
	) % [
		selectedCharacter.characterClass.className,
		selectedCharacter.level,
		selectedCharacter.maxHp
	]

func _on_button_pressed() -> void:
	GameManager.confirmPositioning()
