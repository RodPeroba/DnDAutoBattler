extends Node

var characters : Array[BaseCharacter] = []

func _ready() -> void:
	set_up_battle_interface(characters)

func register_character(character : BaseCharacter):
	characters.append(character)

func remove_character(character : BaseCharacter):
	characters.erase(character)

func step():
	for character in characters:
		if character.currentHp <= 0:
			continue

		character.act()

	print_state()

func print_state():

	print("======")

	for character in characters:

		print(
			"Team: ",
			character.team,
			" Pos: ",
			character.position,
			" HP: ",
			character.currentHp
		)

func isPositionOccupied(pos : Vector2i) -> bool:
	for character in characters:
		if character.position == pos and character.currentHp > 0:
			return true
	return false


func set_up_battle_interface(party:Array[BaseCharacter])->void:
	#TODO
	print("BattleInterface has been setup.")
