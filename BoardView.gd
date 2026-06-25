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
	if GameManager.battleManager == null:
		return
	for character in GameManager.battleManager.characters:
		if character.damage_flash_time > 0:
			character.damage_flash_time -= delta
		if character.attack_animation_time > 0:
			character.attack_animation_time -= delta
		if character.projectile_animation_time > 0:
			character.projectile_animation_time -= delta
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
			drawProjectiles()

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

		var rect = Rect2(screenPosition, Vector2(TILE_SIZE, TILE_SIZE))

		# -------------------------
		# 1. RACE ICON (base)
		# -------------------------
		if character.race != null and character.race.icon != null:
			draw_texture_rect(
				character.race.icon,
				rect,
				false
			)
		else:
			draw_rect(rect, Color.BLUE)

		# -------------------------
		# 2. CLASS ICON (overlay)
		# -------------------------
		if character.characterClass != null and character.characterClass.icon != null:

			var class_icon = character.characterClass.icon

			# menor que o tile (ex: 40% do tamanho)
			var scaling = 0.4
			var draw_size = Vector2(TILE_SIZE, TILE_SIZE) * scaling

			var offset = Vector2(
				TILE_SIZE - draw_size.x - 4,
				4
			)

			draw_texture_rect(
				class_icon,
				Rect2(screenPosition + offset, draw_size),
				false
			)

		if character.characterClass != null:
			draw_string(
				ThemeDB.fallback_font,
				screenPosition + Vector2(4, 18),
				character.characterClass.className.substr(0, 1),
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				14
			)
			
func drawProjectiles():
	if GameManager.battleManager == null:
		return

	for character in GameManager.battleManager.characters:

		if character.projectile_animation_time <= 0:
			continue

		var progress = 1.0 - (
			character.projectile_animation_time / 0.25
		)

		var start_pos = (
			Vector2(character.projectile_start)
			* TILE_SIZE
		) + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

		var target_pos = (
			Vector2(character.projectile_target)
			* TILE_SIZE
		) + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

		var projectile_pos = start_pos.lerp(
			target_pos,
			progress
		)

		draw_circle(
			projectile_pos,
			4,
			Color.WHITE
		)

func drawBattleCharacters():
	if GameManager.battleManager == null:
		return
	for character in GameManager.battleManager.characters:
		var pos = Vector2(character.position * TILE_SIZE)
		if character.attack_animation_time > 0:
			var progress = 1.0 - (
				character.attack_animation_time / 0.15
			)

			var attack_offset = (
				sin(progress * PI)
				* 12.0
			)
			pos += (
				character.attack_direction
				* attack_offset
			)
		var rect = Rect2(pos, Vector2(TILE_SIZE, TILE_SIZE))

		# =====================================
		# COR DO TIME
		# =====================================

		var border_color = Color.BLUE

		if character.team == 1:
			border_color = Color.RED

		# =====================================
		# RAÇA (FUNDO)
		# =====================================

		if character.race != null and character.race.icon != null:
			draw_texture_rect(
				character.race.icon,
				rect,
				false
			)
		else:
			draw_rect(rect, border_color)

		if character.damage_flash_time > 0:
			draw_rect(rect, Color(1, 1, 1, 0.45))
		# =====================================
		# HP BAR
		# =====================================

		var hp_percent := 0.0

		if character.maxHp > 0:
			hp_percent = float(character.currentHp) / character.maxHp

		draw_rect(
			Rect2(
				pos + Vector2(2, 2),
				Vector2(TILE_SIZE - 4, 4)
			),
			Color(0.15, 0.15, 0.15)
		)

		draw_rect(
			Rect2(
				pos + Vector2(2, 2),
				Vector2((TILE_SIZE - 4) * hp_percent, 4)
			),
			Color.GREEN
		)

		# =====================================
		# MANA BAR
		# =====================================

		var mana_percent := 0.0

		if character.maxMana > 0:
			mana_percent = float(character.currentMana) / character.maxMana

		draw_rect(
			Rect2(
				pos + Vector2(2, 8),
				Vector2(TILE_SIZE - 4, 4)
			),
			Color(0.15, 0.15, 0.15)
		)

		draw_rect(
			Rect2(
				pos + Vector2(2, 8),
				Vector2((TILE_SIZE - 4) * mana_percent, 4)
			),
			Color.CYAN
		)

		# =====================================
		# ÍCONE DA CLASSE
		# =====================================

		if character.characterClass != null and character.characterClass.icon != null:

			var icon_size = TILE_SIZE * 0.55

			draw_texture_rect(
				character.characterClass.icon,
				Rect2(
					pos + Vector2(
						(TILE_SIZE - icon_size) / 2,
						14
					),
					Vector2(icon_size, icon_size)
				),
				false
			)

		# =====================================
		# BORDA DO TIME
		# =====================================

		draw_rect(
			rect,
			border_color,
			false,
			2
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
