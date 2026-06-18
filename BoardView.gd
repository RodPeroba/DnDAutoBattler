class_name BoardView
extends Node2D

const TILE_SIZE := 32
const GRID_SIZE := 16

@export var groundTileMap : TileMapLayer

var deployPositions : Array[Vector2i] = [
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

	centerBoard()

	if groundTileMap != null:

		groundTileMap.position = Vector2.ZERO
		groundTileMap.z_index = -1

func _process(delta):

	queue_redraw()

func centerBoard():

	var boardSize = Vector2(
		GRID_SIZE * TILE_SIZE,
		GRID_SIZE * TILE_SIZE
	)

	var viewportSize = (
		get_viewport_rect().size
	)

	position = (
		viewportSize - boardSize
	) / 2.0

func _draw():

	drawGrid()

	match GameManager.currentState:

		GameManager.GameState.POSITIONING:

			drawDeployArea()
			drawPositioningCharacters()

		GameManager.GameState.BATTLE:

			drawBattleCharacters()

func drawGrid():

	for x in range(GRID_SIZE + 1):

		draw_line(
			Vector2(x * TILE_SIZE, 0),
			Vector2(
				x * TILE_SIZE,
				GRID_SIZE * TILE_SIZE
			),
			Color.WHITE
		)

	for y in range(GRID_SIZE + 1):

		draw_line(
			Vector2(0, y * TILE_SIZE),
			Vector2(
				GRID_SIZE * TILE_SIZE,
				y * TILE_SIZE
			),
			Color.WHITE
		)

func drawDeployArea():

	for tile in deployPositions:

		draw_rect(
			Rect2(
				Vector2(tile * TILE_SIZE),
				Vector2(
					TILE_SIZE,
					TILE_SIZE
				)
			),
			Color(0, 0.5, 0, 0.25)
		)

func drawPositioningCharacters():

	if GameManager.playerParty == null:
		return

	for character in GameManager.playerParty.characters:

		var screenPosition = Vector2(
			character.position * TILE_SIZE
		)

		draw_rect(
			Rect2(
				screenPosition,
				Vector2(
					TILE_SIZE,
					TILE_SIZE
				)
			),
			Color.BLUE
		)

		if character.characterClass != null:

			draw_string(
				ThemeDB.fallback_font,
				screenPosition + Vector2(4,18),
				character.characterClass.className.substr(0,1),
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				14
			)

func drawBattleCharacters():

	if GameManager.battleManager == null:
		return

	for character in GameManager.battleManager.characters:

		var screenPosition = Vector2(
			character.position * TILE_SIZE
		)

		var color = Color.BLUE

		if character.team == 1:
			color = Color.RED

		draw_rect(
			Rect2(
				screenPosition,
				Vector2(
					TILE_SIZE,
					TILE_SIZE
				)
			),
			color
		)

		draw_string(
			ThemeDB.fallback_font,
			screenPosition + Vector2(2,14),
			str(character.currentHp),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			12
		)

		draw_string(
			ThemeDB.fallback_font,
			screenPosition + Vector2(2,28),
			str(character.currentMana),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			10
		)

func screenToTile(
	screenPosition : Vector2
) -> Vector2i:

	var localPosition = (
		screenPosition - global_position
	)

	return Vector2i(
		floor(localPosition.x / TILE_SIZE),
		floor(localPosition.y / TILE_SIZE)
	)

func tileToScreen(
	tile : Vector2i
) -> Vector2:

	return global_position + Vector2(
		tile.x * TILE_SIZE,
		tile.y * TILE_SIZE
	)

func isInsideBoard(
	tile : Vector2i
) -> bool:

	return (
		tile.x >= 0
		and tile.y >= 0
		and tile.x < GRID_SIZE
		and tile.y < GRID_SIZE
	)
