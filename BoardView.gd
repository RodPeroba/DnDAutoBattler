class_name BoardView
extends Node2D

const TILE_SIZE := 32
const GRID_SIZE := 16

func _process(delta):
	queue_redraw()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		GameManager.nextStep()

func _draw():
	drawGrid()
	drawCharacters()

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

func drawCharacters():

	if GameManager.battleManager == null:
		return

	for character in GameManager.battleManager.characters:

		var position = Vector2(
			character.position * TILE_SIZE
		)

		var color = Color.BLUE

		if character.team == 1:
			color = Color.RED

		draw_rect(
			Rect2(
				position,
				Vector2(
					TILE_SIZE,
					TILE_SIZE
				)
			),
			color
		)

		draw_string(
			ThemeDB.fallback_font,
			position + Vector2(2, 14),
			str(character.currentHp),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			12
		)

		draw_string(
			ThemeDB.fallback_font,
			position + Vector2(2, 28),
			str(character.currentMana),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			10
		)
