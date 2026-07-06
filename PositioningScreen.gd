extends Control

@export var boardView : BoardView
@export var infoLabel : Label
@export var confirmButton : Button

@onready var inv_ui = $Inv_UI
@onready var party_equip_ui = $Party_Equip_UI

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

	if GameManager.playerParty.characters.size() > 0:
		selectedCharacter = GameManager.playerParty.characters[0]
		GameManager.selectCharacter(selectedCharacter)

	boardView.queue_redraw()
	updateInfo()

func _input(event):
	if GameManager.currentState != GameManager.GameState.POSITIONING:
		return

	if event.is_action_pressed("i"):
		toggle_inventories()
		return

	if event is InputEventMouseButton:
		if !event.pressed:
			return

		if event.button_index != MOUSE_BUTTON_LEFT:
			return

		var tile = boardView.screenToTile(event.position)
		handleTileClick(tile)

func toggle_inventories():
	if inv_ui == null or party_equip_ui == null:
		return

	var should_close = inv_ui.is_open or party_equip_ui.is_open

	if should_close:
		inv_ui.close()
		party_equip_ui.close()
	else:
		inv_ui.open()
		party_equip_ui.open()


		inv_ui.z_index = 200
		party_equip_ui.z_index = 201

		inv_ui.move_to_front()
		party_equip_ui.move_to_front()
		
		
func handleTileClick(tile : Vector2i):

	# Seleciona personagem
	for character in GameManager.playerParty.characters:

		if character.position == tile:

			selectedCharacter = character
			GameManager.selectCharacter(character)

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
		+ "Level %d") % [
		selectedCharacter.characterClass.className,
		selectedCharacter.level
	]

func _on_button_pressed() -> void:
	GameManager.confirmPositioning()
